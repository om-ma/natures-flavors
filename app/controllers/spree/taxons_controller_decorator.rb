Spree::TaxonsController.class_eval do
  def show
    if !http_cache_enabled? || stale?(etag: etag, last_modified: last_modified, public: true)
      load_products
    end
  end

  def load_products

    search_params = params.merge(
      current_store: current_store,
      taxon: @taxon,
      include_images: true
    )
    
    if params[:sort_by] == "bestsellers"
      search_params.delete :sort_by
    end

    @searcher = build_searcher(search_params)
    products_searcher = @searcher.retrieve_products

    if params[:sort_by] == "bestsellers"
      @products =  products_searcher.best_sellers
    else
      @products =   products_searcher
    end
  end
end
