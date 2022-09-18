Spree::PaypalController.class_eval do

  # Override to manually switch to writing db connection in context of readonly action
  def confirm
    order = current_order || raise(ActiveRecord::RecordNotFound)
    ActiveRecord::Base.connected_to(role: :writing) do
      order.payments.create!({
        source: Spree::PaypalExpressCheckout.create({
          token: params[:token],
          payer_id: params[:PayerID]
        }),
        amount: order.total,
        payment_method: payment_method
      })
      order.next
    end
    if order.complete?
      flash.notice = Spree.t(:order_processed_successfully)
      flash[:order_completed] = true
      session[:order_id] = nil
      redirect_to completion_route(order)
    else
      redirect_to checkout_state_path(order.state)
    end
  end

end
