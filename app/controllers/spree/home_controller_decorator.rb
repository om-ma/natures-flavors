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

    if http_cache_enabled?
      fresh_when etag: store_etag, last_modified: last_modified_index, public: true
    end

    @home_slides 		           = Rails.cache.fetch("@home_slides", expires_in: Rails.configuration.x.cache.expiration) do
      Spree::Slide.published.order('position ASC').includes([image_attachment: :blob, mobile_image_attachment: :blob])
    end
    
    @best_sellers_products     = Rails.cache.fetch("@best_sellers_products", expires_in: Rails.configuration.x.cache.expiration) do
      Spree::Product.best_sellers.present? ? Spree::Product.best_sellers.first(6) : []
    end
    
    @deals_products            = Spree::Product.with_variant_sales.present? ? Spree::Product.with_variant_sales.first(6) : []
    
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
    
    @active_home_tab = [@best_sellers_products.count, @deals_products.count, @popular_extracts_products.count, @popular_powders_products.count, @popular_oils_products.count ].index{ |x| x > 0 }
  end

def sale
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

    # TODO: Refactor to include sales in searcher builder
    if params[:id]
      @taxon = Spree::Taxon.find_by!(slug: params[:id])
      @products = products_searcher.with_variant_sales.in_taxon(@taxon)
    else
      @products = products_searcher.with_variant_sales
    end
    @taxonomies = Spree::Taxonomy.includes(root: :children)

    # @products = Spree::Product.where(id: @products.pluck(:id))
    
    unless @products.present?
      redirect_to root_path
    end
  end

end