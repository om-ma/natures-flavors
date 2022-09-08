Spree::TaxonsController.class_eval do
  before_action :load_taxon_with_children, only: :show
  before_action :load_taxon, except: :all_categories

  def show
    @is_top_level_menu_item = @taxon.is_top_level_menu_item
    
    if @is_top_level_menu_item
      load_most_popular_products
    else
      load_products
    end

    fresh_when etag: etag_show, last_modified: last_modified_show, public: true
  end

  private
  
  def load_taxon_with_children
    @taxon = Spree::Taxon.includes(:children).references(:children).friendly.find(params[:id])
  end

  def load_most_popular_products
    ids = Rails.cache.fetch("@pmost-popular-products/taxon/#{@taxon.name}", expires_in: Rails.configuration.x.cache.expiration) do
      @taxon.products.reorder(popularity: :desc).limit(6).pluck(:id)
    end
    @products = Spree::Product.where(id: ids).includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices)
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
  
  def etag_show
    [
      store_etag,
      @taxon,
      @products.maximum(:updated_at).to_f
    ]
  end

  def last_modified_show
    products_last_modified      = @products.maximum(:updated_at).utc
    taxon_last_modified         = @taxon&.updated_at&.utc
    current_store_last_modified = current_store.updated_at.utc

    [products_last_modified, taxon_last_modified, current_store_last_modified].compact.max
  end

end
