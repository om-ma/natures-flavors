Spree::TaxonsController.class_eval do

  before_action :load_taxon_with_children, only: :show
  before_action :load_taxon, except: :all_categories

  def show
    @per_page = 24
    params['per_page'] = @per_page

    if !http_cache_enabled? || stale?(etag: etag, last_modified: last_modified, public: true)
      @is_top_level_menu_item = @taxon.is_top_level_menu_item
      if @is_top_level_menu_item
        load_most_popular_products
      else
        load_products
      end
    end
  end

  def load_taxon_with_children
    @taxon = Spree::Taxon.includes(children: :children).references(children: :children).friendly.find(params[:id])
  end

  def load_most_popular_products
    search_params = {
      sort_by: 'descend_by_popularity',
      current_store: current_store,
      taxon: @taxon,
      include_images: true
    }
    
    @searcher = build_searcher(search_params)
    @products = products_searcher = @searcher.retrieve_products.includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices).limit(6)
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
    products_searcher = @searcher.retrieve_products

    if params[:sort_by] == "bestsellers"
      @products = products_searcher.includes(:product_properties).best_sellers
    else
      @products = products_searcher.includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices)
    end
  end

  def all_categories

  end

end
