Spree::OrdersController.class_eval do
  def edit
    @best_sellers_product = Spree::Product.best_sellers.present? ? Spree::Product.best_sellers.sample : ""
    @order = current_order || current_store.orders.incomplete.
             includes(line_items: [variant: [:images, :product, option_values: :option_type]]).
             find_or_initialize_by(token: cookies.signed[:token])
    associate_user
  end
end