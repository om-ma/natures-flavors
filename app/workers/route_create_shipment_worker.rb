class RouteCreateShipmentWorker
  include Sidekiq::Worker

  def perform(shipment_id)
    return if Rails.configuration.x.route.integration_enabled == 'false'

    client = RouteAPI::V1::Client.new
    token  = Rails.configuration.x.route.secret_token
    shipment = Spree::Shipment.where(id: shipment_id).first

    begin
      client.create_shipment(token, shipment)
      Rails.logger.info "ROUTE: Successfully created shipment: #{shipment.number}"
    rescue StandardError => e
      Spree::ErrorMailer.shipment_error_email(shipment.number, shipment.order.number, e.message).deliver_later
      Rails.logger.error "ROUTE: Failed to create shipment: #{shipment.number}"
      Rails.logger.error e
    end
  end

end