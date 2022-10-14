Spree::CheckoutController.class_eval do

  before_action :update_route_insurance_price, only: [:edit]

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

  def update_route_insurance_price
    if @order.state == 'address' && @order.route_insurance_selected
      client = RouteAPI::V1::Client.new
      token  = Rails.configuration.x.route.public_token

      quote = Rails.cache.fetch("@route/quote/subtotal/#{@order.item_total}", expires_in: Rails.configuration.x.cache.route_quote_expiration, race_condition_ttl: 30.seconds) do
        begin
          response = client.quote(token, @order.item_total, @order.currency)
          @order.route_insurance_price = response['insurance_price'].to_f  
        rescue StandardError => e
          @order.route_insurance_selected = false
  
          Spree::ErrorMailer.order_error_email(@order.number, e.message).deliver_later
          Rails.logger.info "Route: Failed to update insurance price for order: #{@order.number}"
          Rails.logger.info e

          0.00
        end
      end
      
      ActiveRecord::Base.connected_to(role: :writing) do
        @order.route_insurance_price = quote
        @order.update_totals
        @order.persist_totals
        @order.save!
      end
    end
  end

end
