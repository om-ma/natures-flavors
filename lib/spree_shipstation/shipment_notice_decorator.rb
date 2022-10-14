SpreeShipstation::ShipmentNotice.class_eval do

    def apply
      unless shipment
        raise ShipmentNotFoundError, shipment
      end

      process_payment
      ship_shipment

      route_create_shipment

      shipment
    end

    private

    def route_create_shipment
      RouteCreateShipmentWorker.perform_async(shipment.id)
    end
    
  end
end
