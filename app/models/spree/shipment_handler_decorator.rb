Spree::ShipmentHandler.class_eval do
  # Override to update production state
  def perform
    @shipment.inventory_units.each &:ship!
    @shipment.process_order_payments if Spree::Config[:auto_capture_on_dispatch]
    @shipment.touch :shipped_at
    update_order_shipment_state
    update_order_production_state
    send_shipped_email
  end

  private

  def update_order_production_state
    order = @shipment.order

    new_state = Spree::OrderUpdater.new(order).update_production_state
    order.update_columns(production_state: new_state, updated_at: Time.current)
  end
end
