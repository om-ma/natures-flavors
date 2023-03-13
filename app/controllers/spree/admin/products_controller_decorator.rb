Spree::Admin::ProductsController.class_eval do

  def clear_product_cache
    ClearProductCacheWorker.perform_async(params[:id])
  end

end
