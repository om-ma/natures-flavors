module Spree
  module ProductsControllerDecorator
    def index
      redirect_to page_not_found_path
    end
    def show
      @best_sellers = Spree::Product.best_sellers
      if @best_sellers.present?
        byebug
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
        @product_images = product_images(@product, @variants)
        @related_products = @taxon&.products.present? ? @taxon&.products.where.not(id: @product.id)&.last(2) : []
      end
    end
  end
end
::Spree::ProductsController.prepend Spree::ProductsControllerDecorator
