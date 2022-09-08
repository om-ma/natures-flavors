Spree::TaxonsController.class_eval do
  before_action :load_taxon_with_children, only: :show
  before_action :load_taxon, except: :all_categories

  def show
    @is_top_level_menu_item = @taxon.is_top_level_menu_item
    
    if @is_top_level_menu_item
      if !http_cache_enabled? || stale?(etag: etag_show_top_level_menu_item, last_modified: last_modified_show_top_level_menu_item, public: true)
        load_most_popular_products
      end
    else
      if !http_cache_enabled? || stale?(etag: etag, last_modified: last_modified, public: true)
        load_products
      end
    end
  end

  private
  
  def load_taxon_with_children
    @taxon = Spree::Taxon.includes(:children).references(:children).friendly.find(params[:id])
  end

  def load_most_popular_products
    @products = Rails.cache.fetch("@pmost-popular-products/taxon/#{@taxon.name}", expires_in: Rails.configuration.x.cache.expiration) do
      @taxon.products.includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices).reorder(popularity: :desc).limit(6)
    end
  end

  def load_products    
    if params[:sort_by].blank?
      params[:sort_by] = "name-a-z"
    end

    search_params = params.merge(
      current_store: current_store,
      taxon: @taxon,
      include_images: true
    )
    
    if params[:sort_by] == "bestsellers"
      search_params.delete :sort_by
    end

    @searcher = build_searcher(search_params)

    if (browser.device.mobile? || browser.device.tablet?)
      @pagy, @products_searcher = pagy(@searcher.retrieve_products, size: Pagy::DEFAULT[:size_mobile])
    else
      @pagy, @products_searcher = pagy(@searcher.retrieve_products)
    end

    if params[:sort_by] == "bestsellers"
      @products = @products_searcher.includes(:product_properties).best_sellers
    else
      #@products = @products_searcher.includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices)
      @products = @products_searcher
    end
  end

  def all_categories

  end

  def etag_show_top_level_menu_item
    [
      store_etag,
      @taxon
    ]
  end

  def last_modified_show_top_level_menu_item
    taxon_last_modified = @taxon&.updated_at&.utc
    current_store_last_modified = current_store.updated_at.utc

    [taxon_last_modified, current_store_last_modified].compact.max
  end

end
