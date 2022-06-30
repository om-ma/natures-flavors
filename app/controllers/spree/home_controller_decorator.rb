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
    @home_slides 		           = Spree::Slide.published.order('position ASC').includes([image_attachment: :blob, mobile_image_attachment: :blob])
    @best_sellers_products     = Spree::Product.best_sellers.present? ? Spree::Product.best_sellers.first(6) : []
    @deals_products            = Spree::Product.in_sale.present? ? Spree::Product.in_sale.first(6) : []
    popular_extracts           = Spree::Taxon.find_by_name("Flavor Extracts").present? ? Spree::Taxon.find_by_name("Flavor Extracts") : ''
    @popular_extracts_products = popular_extracts.present? ?  popular_extracts.products.reorder(popularity: :desc).first(6) : [] 
    popular_powders            = Spree::Taxon.find_by_name("Flavor Powders").present? ? Spree::Taxon.find_by_name("Flavor Powders") : ''
    @popular_powders_products  = popular_powders.present? ? popular_powders.products.reorder(popularity: :desc).first(6) : [] 
    popular_oils               = Spree::Taxon.find_by_name("Flavor Oils").present? ? Spree::Taxon.find_by_name("Flavor Oils") : ''
    @popular_oils_products     = popular_oils.present? ? popular_oils.products.reorder(popularity: :desc).first(6) : []
    @active_home_tab           = [@best_sellers_products.count, @deals_products.count, @popular_extracts_products.count, @popular_powders_products.count, @popular_oils_products.count ].index{ |x| x > 0 }
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