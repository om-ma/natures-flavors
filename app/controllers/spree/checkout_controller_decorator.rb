Spree::CheckoutController.class_eval do

  # Override to manually switch to writing db connection in context of readonly action
  def ensure_valid_state
    if @order.state != correct_state && !skip_state_validation?
      flash.keep
      ActiveRecord::Base.connected_to(role: :writing) do
        @order.update_column(:state, correct_state)
      end
      redirect_to spree.checkout_state_path(@order.state)
    end
  end

  def load_order_with_lock
    ActiveRecord::Base.connected_to(role: :writing) do
      @order = current_order(lock: true)
    end
    redirect_to(spree.cart_path) && return unless @order
  end

end
