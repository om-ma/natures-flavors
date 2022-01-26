module Spree
  class HomeController < Spree::StoreController

    include Spree::CacheHelper
    helper 'spree/products'

    before_action :load_homepage, only: [:index]

    respond_to :html

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
    end

		def sale
      

      # TODO: Refactor to include sales in searcher builder
      if params[:id]
        @taxon = Spree::Taxon.find_by!(slug: params[:id])
        @products = Spree::Product.in_sale.in_taxon(@taxon)
      else
        @products = Spree::Product.in_sale
      end
      @taxonomies = Spree::Taxonomy.includes(root: :children)

      @products = Spree::Product.where(id: @products.pluck(:id))

      if @products.count == 0
        redirect_to root_path
      end
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
      @taxon = Spree::Taxon.friendly.find(params[:id])
      return unless @taxon
      @searcher = build_searcher(params.merge(taxon: @taxon, include_images: true))
      list      = ['descend_by_popularity', 'ascend_by_name', 'descend_by_name']

      if list.include?(params[:sorting])
        sorting_scope = params[:sorting].try(:to_sym) || :ascend_by_name
      else
        sorting_scope = :ascend_by_name
      end

      @products   = @searcher.retrieve_products.send(sorting_scope).page(params[:page]).per(params['per_page'])
      @taxonomies = Spree::Taxonomy.includes(root: :children).where('name ILIKE ?','%PRODUCTS%')
    end
    end

    private

    def etag_index
      [
        store_etag,
        last_modified_index,
      ]
    end

    def last_modified_index
      page_last_modified = @cms_home_page&.maximum(:updated_at)&.utc if @cms_home_page.respond_to?(:maximum)
      current_store_last_modified = current_store.updated_at.utc

      [page_last_modified, current_store_last_modified].compact.max
    end

    def accurate_title
      @cms_home_page&.seo_title || super
    end

    def load_homepage
      @cms_home_page = current_store.homepage(I18n.locale)
    end
  end
end
