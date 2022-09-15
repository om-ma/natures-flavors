Spree::Admin::PaymentsController.class_eval do

  def new
    ActiveRecord::Base.connected_to(role: :writing) do
      # Move order to payment state in order to capture tax generated on shipments
      @order.next if @order.can_go_to_state?('payment')
      @payment = @order.payments.build
    end
  end

end
