module Spree
  module Admin
    OrdersController.class_eval do

      # Override for Production state
      before_action :load_order, only: %i[
        edit update cancel resume approve resend open_adjustments
        close_adjustments cart channel set_channel
        production set_production
      ]
      
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
          else
            flash[:error] = @order.errors.full_messages.join(', ')
          end

          redirect_to admin_order_state_changes_url(@order)
        else 
          flash[:error] = Spree.t(:production_state_selected_same_as_previous)

          redirect_to production_admin_order_url(@order)
        end
      end

    end
  end
end