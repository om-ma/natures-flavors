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

  # Override to add Route insurance
  def payment_details items
    # This retrieves the cost of shipping after promotions are applied
    # For example, if shippng costs $10, and is free with a promotion, shipment_sum is now $10
    shipment_sum = current_order.shipments.map(&:discounted_cost).sum

    # This calculates the item sum based upon what is in the order total, but not for shipping
    # or tax.  This is the easiest way to determine what the items should cost, as that
    # functionality doesn't currently exist in Spree core
    if current_order.route_insurance_selected
      item_sum = current_order.total - shipment_sum - current_order.additional_tax_total - current_order.route_insurance_price
    else
      item_sum = current_order.total - shipment_sum - current_order.additional_tax_total
    end

    if item_sum.zero?
      # Paypal does not support no items or a zero dollar ItemTotal
      # This results in the order summary being simply "Current purchase"
      {
        OrderTotal: {
          currencyID: current_order.currency,
          value: current_order.total
        }
      }
    else
      insurance_sum = nil
      if current_order.route_insurance_selected
        insurance_sum = {
          currencyID: current_order.currency,
          value: current_order.route_insurance_price,
        }
      end
      
      {
        OrderTotal: {
          currencyID: current_order.currency,
          value: current_order.total
        },
        ItemTotal: {
          currencyID: current_order.currency,
          value: item_sum
        },
        ShippingTotal: {
          currencyID: current_order.currency,
          value: shipment_sum,
        },
        TaxTotal: {
          currencyID: current_order.currency,
          value: current_order.additional_tax_total
        },
        InsuranceTotal: insurance_sum,
        ShipToAddress: address_options,
        PaymentDetailsItem: items,
        ShippingMethod: "Shipping Method Name Goes Here",
        PaymentAction: "Sale"
      }.compact
    end
  end
  
end
