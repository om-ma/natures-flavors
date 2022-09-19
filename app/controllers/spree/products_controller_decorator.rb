module Spree
  module ProductsControllerDecorator

    def self.prepended(base)
      base.after_action :update_product_popularity, only: :show
    end

    MAX_BEST_SELLERS = 100

    def index
      redirect_to page_not_found_path
    end
    
    def show
      best_sellers_product_id = Rails.cache.fetch(cache_key_for_best_sellers_product(@product), expires_in: Rails.configuration.x.cache.expiration, race_condition_ttl: 30.seconds) do
        best_sellers_ids = Rails.cache.fetch("@best_sellers/count/#{MAX_BEST_SELLERS}", expires_in: Rails.configuration.x.cache.expiration, race_condition_ttl: 30.seconds) do
          Spree::Product.best_sellers.take(MAX_BEST_SELLERS).pluck(:id)
        end
        best_sellers = Spree::Product.where(id: best_sellers_ids).includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices)
        
        # Pick one best seller product
        best_sellers_product = nil
        if best_sellers.present?
          loop do
            best_sellers_product = best_sellers.sample
            break if best_sellers_product.option_types.count == 1
          end
        end
        
        if best_sellers_product.present? 
          best_sellers_product.id
        else
          nil
        end
      end
      @best_sellers_product = Spree::Product.where(id: best_sellers_product_id).includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices).first

      redirect_if_legacy_path

      @taxon = params[:taxon_id].present? ? taxons_scope.find_by(id: params[:taxon_id]) : nil
      @taxon = @product.taxons.first unless @taxon.present?

      @product_summary = Spree::ProductSummaryPresenter.new(@product).call
      @product_properties = @product.product_properties.includes(:property)
      @product_price = @product.price_in(current_currency).amount
      load_variants
      @variants_master_only_or_no_master = (@variants.count == 1 ? @variants : @variants.reject { |v| v.is_master } )
      @product_images = product_images(@product, @variants)

      related_products_ids = Rails.cache.fetch(cache_key_for_related_product(@product), expires_in: Rails.configuration.x.cache.expiration, race_condition_ttl: 30.seconds) do
        if @product.has_related_products?('related') &&  @product.related.count > 0
          @product.related.take(2).pluck(:id)
        else
          @taxon&.products.where.not(id: @product.id).where(deleted_at: nil).where(discontinue_on: nil).take(2).pluck(:id)
        end
      end
      @related_products = Spree::Product.where(id: related_products_ids).includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices)
      
      fresh_when etag: etag_show, last_modified: last_modified_show, public: true
    end

    def related_products_max_updated_at
      if @related_products.present?
        @related_products.max_by(&:updated_at).updated_at
      else
         Date.today
      end
    end

    def etag_show
      [
        store_etag,
        @product,
        @taxon,
        @product.possible_promotion_ids,
        @product.possible_promotions.maximum(:updated_at),
        @best_sellers_product,
        related_products_max_updated_at.to_s(:number)
      ]
    end
    
    def last_modified_show
      product_last_modified              = @product.updated_at.utc
      current_store_last_modified        = current_store.updated_at.utc
      best_sellers_product_last_modified = (@best_sellers_product.present? ? @best_sellers_product.updated_at.utc : nil)
      related_products_last_modified     = (@related_products.present? ? related_products_max_updated_at.utc : nil)

      [product_last_modified, current_store_last_modified, best_sellers_product_last_modified, related_products_last_modified].compact.max
    end

    def load_product
      id = Rails.cache.fetch(cache_key_for_product_by_friendly_url(params[:id]), expires_in: Rails.configuration.x.cache.expiration, race_condition_ttl: 30.seconds) do
        current_store.products.for_user(try_spree_current_user).friendly.find(params[:id]).id
      end
      @product = Spree::Product.where(id: id).includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices).first
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
        @per_page = Pagy::DEFAULT[:items]
        
        if params[:sort_by] == 'name-a-z'
          @sort_by = { sort: { title: 'asc' } }
        elsif params[:sort_by] == 'name-z-a'
          @sort_by = { sort: { title: 'desc' } }
        else
          @sort_by = nil
        end

        @results_json = client.search(api_key, hashid, @keywords, 'match_and', 'product', @filter, @page, @per_page, @sort_by)

        if @results_json['total'].to_i == 0
          @results_json = client.search(api_key, hashid, @keywords, 'fuzzy', 'product', @filter, @page, @per_page, @sort_by)
        end
      rescue StandardError => e
        Rails.logger.warn "Doofinder: Failed to search for: #{@keywords}"
        Rails.logger.warn e

        @results_json = {}
      end

      if params[:ajax]
        render template: 'spree/products/_search_products', locals: { results_json: @results_json, keywords: @keywords }, layout: false
      end
    end

    private

    def update_product_popularity
      ActiveRecord::Base.connected_to(role: :writing) do
        @product.popularity += 1
        @product.save
      end
    end
    
  end
end
::Spree::ProductsController.prepend Spree::ProductsControllerDecorator
