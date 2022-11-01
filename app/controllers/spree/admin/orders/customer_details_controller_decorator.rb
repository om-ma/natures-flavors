module Spree
  module Admin
    module Orders
      CustomerDetailsController.class_eval do

        after_action :route_update_order, only: %i[
          edit update
        ]

        def route_update_order
          RouteUpdateOrderWorker.perform_async(@order.id)
        end

      end
    end
  end
end
