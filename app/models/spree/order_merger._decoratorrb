Spree::OrderMerger.class_eval do

  def merge!(other_order, user = nil)
    ActiveRecord::Base.connected_to(role: :writing) do
      other_order.line_items.each do |other_order_line_item|
        next unless other_order_line_item.currency == order.currency

        current_line_item = find_matching_line_item(other_order_line_item)
        handle_merge(current_line_item, other_order_line_item)
      end

      set_user(user)
      persist_merge

      # So that the destroy doesn't take out line items which may have been re-assigned
      other_order.line_items.reload
      other_order.destroy
    end
  end

end
