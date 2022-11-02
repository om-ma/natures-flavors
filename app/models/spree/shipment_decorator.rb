Spree::Shipment.class_eval do

  def refresh_rates(shipping_method_filter = Spree::ShippingMethod::DISPLAY_ON_FRONT_END)
    return shipping_rates if shipped?
    return [] unless can_get_rates?

    # StockEstimator.new assigment below will replace the current shipping_method
    original_shipping_method_id = shipping_method.try(:id)

    ActiveRecord::Base.connected_to(role: :writing) do
      self.shipping_rates = Spree::Stock::Estimator.new(order).
                            shipping_rates(to_package, shipping_method_filter)

      if shipping_method
        selected_rate = shipping_rates.detect do |rate|
          if original_shipping_method_id
            rate.shipping_method_id == original_shipping_method_id
          else
            rate.selected
          end
        end
        save!
        self.selected_shipping_rate_id = selected_rate.id if selected_rate
        reload
      end
    end
    
    shipping_rates
  end

  def update_amounts
    if selected_shipping_rate
      ActiveRecord::Base.connected_to(role: :writing) do
        update_columns(
          cost: selected_shipping_rate.cost,
          adjustment_total: adjustments.additional.map(&:update!).compact.sum,
          updated_at: Time.current
        )
      end
    end
  end

end
