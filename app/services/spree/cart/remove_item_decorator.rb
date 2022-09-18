Spree::Cart::RemoveItem.class_eval do

  def call(order:, variant:, quantity: nil, options: nil)
    options ||= {}
    quantity ||= 1

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connected_to(role: :writing) do
        line_item = remove_from_line_item(order: order, variant: variant, quantity: quantity, options: options)
        Spree::Dependencies.cart_recalculate_service.constantize.call(line_item: line_item,
                                                                      order: order,
                                                                      options: options)
        success(line_item)
      end
    end
  end

end
