module Spree
  module Admin
    OrdersController.class_eval do

      # Override for Production state
      before_action :load_order, only: %i[
        edit update cancel resume approve resend open_adjustments
        close_adjustments cart channel set_channel
        production set_production
        create_route_order
      ]

      after_action :route_cancel_order, only: :cancel
      
      def production
      end

      def set_production
        last_state = @order.production_state
        @order.production_state = params[:order][:production_state]
        if last_state != @order.production_state
          # Save current user for state change
          @order.current_user = spree_current_user
          @order.state_changed('production')

          if @order.update(production_state: params[:order][:production_state])
            flash[:success] = flash_message_for(@order, :successfully_updated)

            if params[:order][:production_state] == 'canceled'
              route_cancel_order
            end
          else
            flash[:error] = @order.errors.full_messages.join(', ')
          end

          redirect_to admin_order_state_changes_url(@order)
        else 
          flash[:error] = Spree.t(:production_state_selected_same_as_previous)

          redirect_to production_admin_order_url(@order)
        end
      end

      def new
        ActiveRecord::Base.connected_to(role: :writing) do
          @order = scope.create(order_params)
        end
        redirect_to cart_admin_order_url(@order)
      end

      def open_adjustments
        adjustments = @order.all_adjustments.finalized
        ActiveRecord::Base.connected_to(role: :writing) do
          adjustments.update_all(state: 'open')
        end
        flash[:success] = Spree.t(:all_adjustments_opened)

        respond_with(@order) { |format| format.html { redirect_back fallback_location: spree.admin_order_adjustments_url(@order) } }
      end

      def close_adjustments
        adjustments = @order.all_adjustments.not_finalized
        ActiveRecord::Base.connected_to(role: :writing) do
          adjustments.update_all(state: 'closed')
        end
        flash[:success] = Spree.t(:all_adjustments_closed)

        respond_with(@order) { |format| format.html { redirect_back fallback_location: spree.admin_order_adjustments_url(@order) } }
      end

      def route_cancel_order
        RouteCancelOrderWorker.perform_async(@order.id)
      end

      def create_route_order
        RouteCreateOrderWorker.perform_async(@order.id)
      end    

    end
  end
end