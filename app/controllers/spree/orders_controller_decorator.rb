Spree::OrdersController.class_eval do
  def edit
    @best_sellers = Spree::Product.best_sellers
    if @best_sellers.present?
      loop do
        @best_sellers_product = @best_sellers.sample
        break if @best_sellers_product.option_types.count == 1
      end
    else
      ""
    end

    @order = current_order || current_store.orders.incomplete.
             includes(line_items: [variant: [:images, :product, option_values: :option_type]]).
             find_or_initialize_by(token: cookies.signed[:token])
    
    ActiveRecord::Base.connected_to(role: :writing) do
      associate_user
    end
  end
end