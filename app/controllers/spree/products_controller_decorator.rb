module Spree
  module ProductsControllerDecorator
    def index
    end
    def show
      @best_sellers_product = Spree::Product.best_sellers.present? ? Spree::Product.best_sellers.sample : ""
      redirect_if_legacy_path

      @taxon = params[:taxon_id].present? ? taxons_scope.find_by(id: params[:taxon_id]) : nil
      @taxon = @product.taxons.first unless @taxon.present?

      if !http_cache_enabled? || stale?(etag: etag_show, last_modified: last_modified_show, public: true)
        @product_summary = Spree::ProductSummaryPresenter.new(@product).call
        @product_properties = @product.product_properties.includes(:property)
        @product_price = @product.price_in(current_currency).amount
        load_variants
        @product_images = product_images(@product, @variants)
        @related_products = @taxon&.products.present? ? @taxon&.products.where.not(id: @product.id)&.last(2) : []
      end
    end
    def result
      @searcher = build_searcher(params.merge(include_images: true, current_store: current_store))
      @products = @searcher.retrieve_products

      if http_cache_enabled?
        fresh_when etag: etag_index, last_modified: last_modified_index, public: true
      end
    end
  end
end
::Spree::ProductsController.prepend Spree::ProductsControllerDecorator
