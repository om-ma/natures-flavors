Spree::TaxonsController.class_eval do
  before_action :load_taxon_with_children, only: :show
  before_action :load_taxon, except: :all_categories

  def show
    #@per_page = Pagy::DEFAULT[:items]
    #params['per_page'] = @per_page

    if !http_cache_enabled? || stale?(etag: etag, last_modified: last_modified, public: true)
      @is_top_level_menu_item = @taxon.is_top_level_menu_item
      @is_hide_most_popular = (@taxon.name == 'Extracts & Flavorings')
      if @is_top_level_menu_item
        if !@is_hide_most_popular
          load_most_popular_products
        end
      else
        load_products
      end
    end
  end

  def load_taxon_with_children
    @taxon = Spree::Taxon.includes(children: :children).references(children: :children).friendly.find(params[:id])
  end

  def load_most_popular_products
    @products = Rails.cache.fetch("@pmost-popular-products/taxon/#{@taxon.name}", expires_in: Rails.configuration.x.cache.expiration) do
      @taxon.products.includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices).reorder(popularity: :desc).first(6)
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

end
