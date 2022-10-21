class RouteUpdateOrderWorker
  include Sidekiq::Worker

  def perform(order_id)
    return if !Rails.configuration.x.route.integration_enabled

    client = RouteAPI::V1::Client.new
    token  = Rails.configuration.x.route.secret_token
    order = Spree::Order.where(id: order_id).first

    begin
      client.update_order(token, order)
      Rails.logger.info "ROUTE: Successfully updated order: #{order.number}"
    rescue StandardError => e
      Spree::ErrorMailer.update_order_error_email(order.number, e.message).deliver_later
      Rails.logger.info "ROUTE: Failed to update order: #{order.number}"
      Rails.logger.info e
    end
  end

end