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

    fresh_when etag: etag_edit, last_modified: last_modified_edit, public: true
  end

  def etag_edit
    [
      store_etag,
      @order
    ]
  end
  
  def last_modified_edit
    @order.updated_at.utc
  end

end