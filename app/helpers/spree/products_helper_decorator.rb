Spree::ProductsHelper.class_eval do
    def cache_key_for_best_sellers(products)
        count = products.length
        max_updated_at = (products.map{|p| p.updated_at }.max || Date.today).to_s(:number)
        products_cache_keys = "spree/best_sellers/all-#{params[:page]}-#{max_updated_at}-#{count}"
      	(common_product_cache_keys + [products_cache_keys]).compact.join('/')
    end
end	
