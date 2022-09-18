Spree::Admin::StockItemsController.class_eval do
  include Spree::Admin::CacheConcern
    
  after_action :clear_cache_by_stock_item, only: [:update, :destroy]
  after_action :clear_cache_by_variant, only: :create

  def clear_cache_by_stock_item
    clear_views_product_cache(@stock_item.variant.product)
  end

  def clear_cache_by_variant
    variant = current_store.variants.find(params[:variant_id])
    clear_views_product_cache(variant.product)
  end

end
    