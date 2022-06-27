Spree::OrderUpdater.class_eval do
  # Override to add update_production_state
  def update
    update_item_count
    update_totals
    if order.completed?
      update_payment_state
      update_shipments
      update_shipment_state
      update_production_state # Added
      update_shipment_total
    end
    run_hooks
    persist_totals
  end

  # Override to add update_production_state
  def persist_totals
    order.update_columns(
      payment_state: order.payment_state,
      production_state: order.production_state, # Added
      shipment_state: order.shipment_state,
      item_total: order.item_total,
      item_count: order.item_count,
      adjustment_total: order.adjustment_total,
      included_tax_total: order.included_tax_total,
      additional_tax_total: order.additional_tax_total,
      payment_total: order.payment_total,
      shipment_total: order.shipment_total,
      promo_total: order.promo_total,
      total: order.total,
      updated_at: Time.current
    )
  end

  def update_production_state
    last_state = order.production_state
    if order.payment_state == 'paid'
      order.production_state = 'ready' if order.production_state.nil?
      order.production_state = 'complete' if order.shipment_state == 'shipped'
    end
    order.state_changed('production') if last_state != order.production_state
    order.production_state
  end

end
