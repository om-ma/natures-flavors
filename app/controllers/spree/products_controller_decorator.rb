module Spree
  module ProductsControllerDecorator
    def index
      redirect_to page_not_found_path
    end
    def show
      @best_sellers = Rails.cache.fetch("@best_sellers", expires_in: Rails.configuration.x.cache.expiration) do
        Spree::Product.best_sellers
      end

      @best_sellers = Spree::Product.best_sellers
      if @best_sellers.present?
        loop do
          @best_sellers_product = @best_sellers.sample
          break if @best_sellers_product.option_types.count == 1
        end
      else
        ""
      end

      redirect_if_legacy_path

      @taxon = params[:taxon_id].present? ? taxons_scope.find_by(id: params[:taxon_id]) : nil
      @taxon = @product.taxons.first unless @taxon.present?

      if !http_cache_enabled? || stale?(etag: etag_show, last_modified: last_modified_show, public: true)
        @product_summary = Spree::ProductSummaryPresenter.new(@product).call
        @product_properties = @product.product_properties.includes(:property)
        @product_price = @product.price_in(current_currency).amount
        load_variants
        @variants_master_only_or_no_master = (@variants.count == 1 ? @variants : @variants.reject { |v| v.is_master } )
        @product_images = product_images(@product, @variants)
        @related_products = @taxon&.products.present? ? @taxon&.products.where.not(id: @product.id).where(deleted_at: nil).where(discontinue_on: nil)&.last(2) : []
      end
    end

    def load_product
      @product = current_store.products.includes(prices: :sale_prices).references(prices: :sale_prices).for_user(try_spree_current_user).friendly.find(params[:id])
    end
    
    def search
      @keywords = params[:keywords]

      if @keywords.blank?
        redirect_to all_categories_path
      end

      client = DoofinderAPI::V5::Client.new
      api_key = Rails.configuration.x.doofinder.api_key
      hashid = Rails.configuration.x.doofinder.hashid

      begin
        @filter = params[:filter].blank? ? nil : { filter: params[:filter].to_unsafe_hash }
        @page = (params[:page].blank? ? 1 : params[:page])
        @per_page = 24
        
        if params[:sort_by] == 'name-a-z'
          @sort_by = { sort: { title: 'asc' } }
        elsif params[:sort_by] == 'name-z-a'
          @sort_by = { sort: { title: 'desc' } }
        else
          # Doofinder defaults to sorting by relevance. Not sure if 'relevance' is they key sorting word in Doofinder.
          @sort_by = { sort: { relevance: 'desc' } }
        end

        @results_json = client.search(api_key, hashid, @keywords, 'match_and', 'product', @filter, @page, @per_page, @sort_by)
      rescue StandardError => e
        Rails.logger.warn "Doofinder: Failed to search for: #{@keywords}"
        Rails.logger.warn e

        @results_json = {}
      end

      if params[:ajax]
        render template: 'spree/products/_search_products', locals: { results_json: @results_json, keywords: @keywords }, layout: false
      end
    end
    
  end
end
::Spree::ProductsController.prepend Spree::ProductsControllerDecorator
