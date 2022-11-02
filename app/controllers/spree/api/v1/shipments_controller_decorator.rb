module Spree
  module Api
    module V1
      ShipmentsController.class_eval do

        after_action :route_update_order, only: [:add, :remove]
        after_action :route_create_shipment, only: :ship

        def route_update_order
          RouteUpdateOrderWorker.perform_async(@shipment.order.id)
        end

        def route_create_shipment
          RouteCreateShipmentWorker.perform_async(@shipment.id)
        end

      end
    end
  end
end
