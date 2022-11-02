module Spree
  module Admin
    module Orders
      CustomerDetailsController.class_eval do

        after_action :route_update_order, only: %i[
          edit update
        ]

        def route_update_order
          if @order.state == 'complete' || @order.state == 'canceled'
            RouteUpdateOrderWorker.perform_async(@order.id)
          end
        end

      end
    end
  end
end
