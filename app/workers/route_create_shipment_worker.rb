class RouteCreateShipmentWorker
  include Sidekiq::Worker

  def perform(shipment_id)
    client = RouteAPI::V1::Client.new
    token  = Rails.configuration.x.route.secret_token
    shipment = Spree::Shipment.where(id: shipment_id).first

    begin
      client.create_shipment(token, shipment)
      Rails.logger.info "ROUTE: Successfully created shipment: #{shipment.number}"
    rescue StandardError => e
      Spree::ErrorMailer.shipment_error_email(shipment.number, e.message).deliver_later
      Rails.logger.info "ROUTE: Failed to create shipment: #{shipment.number}"
      Rails.logger.info e
    end
  end

end