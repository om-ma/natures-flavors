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

    list = ['descend_by_popularity', 'ascend_by_name', 'descend_by_name']
    if list.include?(params[:sorting])
      sorting_scope = params[:sorting].try(:to_sym) || :ascend_by_name
    else
      sorting_scope = :ascend_by_name
    end

    @searcher = build_searcher(search_params)
    products_searcher = @searcher.retrieve_products.send(sorting_scope)

    if params[:sorting] == "bestsellers"
      @products =  products_searcher.best_sellers
    else  
      @products =   products_searcher
    end

  end

end