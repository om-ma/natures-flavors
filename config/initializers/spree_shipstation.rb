# frozen_string_literal: true

SpreeShipstation.configure do |config|
  # Choose between Grams, Ounces or Pounds.
  config.weight_units = "Pounds"

  # ShipStation expects the endpoint to be protected by HTTP Basic Auth.
  # Set the username and password you desire for ShipStation to use.
  config.username = ENV['SHIPSTATION_USERNAME']
  config.password = ENV['SHIPSTATION_PASSWORD']

  # Capture payment when ShipStation notifies a shipping label creation.
  # Set this to `true` and `config.auto_capture_on_dispatch = true` if you
  # want to charge your customers at the time of shipment.
  config.capture_at_notification = false

  # Export canceled shipments to ShipStation
  # Set this to `true` if you want canceled shipments included in the endpoint.
  config.export_canceled_shipments = false
end
