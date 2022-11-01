Spree::CheckoutController.class_eval do

  before_action :get_route_quote, only: [:edit]

  # Override to manually switch to writing db connection in context of readonly action
  def ensure_valid_state
    if @order.state != correct_state && !skip_state_validation?
      flash.keep
      ActiveRecord::Base.connected_to(role: :writing) do
        @order.update_column(:state, correct_state)
      end
      redirect_to spree.checkout_state_path(@order.state)
    end
  end

  def load_order_with_lock
    ActiveRecord::Base.connected_to(role: :writing) do
      @order = current_order(lock: true)
    end
    redirect_to(spree.cart_path) && return unless @order
  end

  def get_route_quote
    if (@order.state == 'address' && !@order.bill_address_id.nil? && !@order.ship_address_id.nil?) || @order.state == 'delivery'
      quote_id, quote_premium, quote_currency = Rails.cache.fetch("@route/quote/order/#{@order.number}/item_total/#{@order.item_total}", expires_in: Rails.configuration.x.cache.route_quote_expiration, race_condition_ttl: 30.seconds) do
        client = RouteAPI::V1::Client.new
        merchant_id = Rails.configuration.x.route.merchant_id
        token = Rails.configuration.x.route.public_token
  
        begin
          response = client.quote(merchant_id, token, @order)

          [response['id'], response['premium']['amount'].to_f, response['premium']['currency']]
        rescue StandardError => e
          Spree::ErrorMailer.order_error_email(@order.number, e.message).deliver_later
          Rails.logger.info "Route: Failed to update insurance price for order: #{@order.number}"
          Rails.logger.info e

          ["", 0.00 ,response['premium']['currency']]
        end
      end
      
      ActiveRecord::Base.connected_to(role: :writing) do
        @order.route_insurance_selected = false if quote_premium == 0.00
        @order.route_insurance_currency = quote_currency
        @order.route_insurance_quote_id = quote_id
        @order.route_insurance_quote_premium = quote_premium
        @order.route_insurance_price = quote_premium if @order.route_insurance_selected
        @order.update_totals
        @order.persist_totals
        @order.save!
      end
    end
  end

end
