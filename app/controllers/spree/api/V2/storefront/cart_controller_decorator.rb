Spree::Api::V2::Storefront::CartController.class_eval do

  def add_item

    result = add_item_service.call(
      order: spree_current_order,
      variant: @variant,
      quantity: params[:quantity],
      options: params[:options]
    )

    render_order(result)
  end
end
