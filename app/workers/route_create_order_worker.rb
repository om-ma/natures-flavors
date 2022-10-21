class RouteCreateOrderWorker
  include Sidekiq::Worker

  def perform(order_id)
    return if !Rails.configuration.x.route.integration_enabled

    client = RouteAPI::V1::Client.new
    token  = Rails.configuration.x.route.secret_token
    order = Spree::Order.where(id: order_id).first

    begin
      client.create_order(token, order)
      Rails.logger.info "ROUTE: Successfully created order: #{order.number}"
    rescue StandardError => e
      Spree::ErrorMailer.order_error_email(order.number, e.message).deliver_later
      Rails.logger.info "ROUTE: Failed to create order: #{order.number}"
      Rails.logger.info e
    end
  end

end