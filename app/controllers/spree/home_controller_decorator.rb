Spree::HomeController.class_eval do
  include Spree::CacheHelper
  helper 'spree/products'
  def index
    if @cms_home_page&.visible?
      @homepage = @cms_home_page
    elsif try_spree_current_user&.admin?
      @homepage = @cms_home_page
      @edit_mode = true
    end

    @home_slides 		           = Spree::Slide.published.order('position ASC').includes([image_attachment: :blob, mobile_image_attachment: :blob])
    
    @best_sellers_products     = Rails.cache.fetch("@best_sellers_products", expires_in: Rails.configuration.x.cache.expiration) do
      Spree::Product.best_sellers.present? ? Spree::Product.best_sellers.first(6) : []
    end
    
    @deals_products            = Spree::Product.in_sale.present? ? Spree::Product.in_sale.first(6) : []
    
    @popular_extracts_products = Rails.cache.fetch("@popular_extracts_products", expires_in: Rails.configuration.x.cache.expiration) do
      popular_extracts           = Spree::Taxon.find_by_name("Flavor Extracts").present? ? Spree::Taxon.find_by_name("Flavor Extracts") : ''
      popular_extracts.present? ?  popular_extracts.products.reorder(popularity: :desc).first(6) : [] 
    end
    
    @popular_powders_products  = Rails.cache.fetch("@popular_powders_products", expires_in: Rails.configuration.x.cache.expiration) do
      popular_powders            = Spree::Taxon.find_by_name("Flavor Powders").present? ? Spree::Taxon.find_by_name("Flavor Powders") : ''
      popular_powders.present? ? popular_powders.products.reorder(popularity: :desc).first(6) : [] 
    end
    
    @popular_oils_products     = Rails.cache.fetch("@popular_oils_products", expires_in: Rails.configuration.x.cache.expiration) do
      popular_oils               = Spree::Taxon.find_by_name("Flavor Oils").present? ? Spree::Taxon.find_by_name("Flavor Oils") : ''
      popular_oils.present? ? popular_oils.products.reorder(popularity: :desc).first(6) : []
    end

    #@active_home_tab = [@best_sellers_products.count, @deals_products.count, @popular_extracts_products.count, @popular_powders_products.count, @popular_oils_products.count ].index{ |x| x > 0 }
    @active_home_tab = [0, @deals_products.count, @popular_extracts_products.count, @popular_powders_products.count, @popular_oils_products.count ].index{ |x| x > 0 }

    if http_cache_enabled?
      fresh_when etag: etag_index, last_modified: last_modified_index, public: true
    end
  end

  def sale
    if params[:sort_by].blank?
      params[:sort_by] = "descend_by_popularity"
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
    @pagy, @products_searcher = pagy(@searcher.retrieve_products)

    if params[:sort_by] == "bestsellers"
      @products = @products_searcher.includes(:product_properties).best_sellers
    else
      @products = @products_searcher.includes(:product_properties).references(:product_properties)
    end
    
    @products = @products_searcher.in_sale
    @taxonomies = Spree::Taxonomy.includes(root: :children)
    
    unless @products.present?
      redirect_to root_path
    end
  end

  def etag_index
    [
      store_etag,
      last_modified_index,
      @home_slides,
      @best_sellers_products,
      @deals_products,
      @popular_extracts_products,
      @popular_powders_products,
      @popular_oils_products
    ]
  end

  def last_modified_index
    page_last_modified = @cms_home_page&.maximum(:updated_at)&.utc if @cms_home_page.respond_to?(:maximum)
    current_store_last_modified = current_store.updated_at.utc

    home_slides_last_modified               = @home_slides.maximum(:updated_at)&.utc if @home_slides.respond_to?(:maximum)
    
    best_sellers_products_last_modified     = @best_sellers_products.maximum(:updated_at)&.utc if @best_sellers_products.respond_to?(:maximum)
    deals_products_last_modified            = @deals_products.maximum(:updated_at)&.utc if @deals_products.respond_to?(:maximum)
    popular_extracts_products_last_modified = @popular_extracts_products.maximum(:updated_at)&.utc if @popular_extracts_products.respond_to?(:maximum)
    popular_powders_products_last_modified  = @popular_powders_products.maximum(:updated_at)&.utc if @popular_powders_products.respond_to?(:maximum)
    popular_oils_products_last_modified     = @popular_oils_products.maximum(:updated_at)&.utc if @popular_oils_products.respond_to?(:maximum)

    [page_last_modified, current_store_last_modified, best_sellers_products_last_modified, deals_products_last_modified, popular_extracts_products_last_modified, popular_powders_products_last_modified, popular_oils_products_last_modified].compact.max
  end

end