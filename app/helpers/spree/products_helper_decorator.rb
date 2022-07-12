Spree::ProductsHelper.class_eval do
    def cache_key_for_best_sellers(products)
        count = products.length
        max_updated_at = (products.map{|p| p.updated_at }.max || Date.today).to_s(:number)
        products_cache_keys = "spree/best_sellers/all-#{params[:page]}-#{max_updated_at}-#{count}"
      	(common_product_cache_keys + [products_cache_keys]).compact.join('/')
    end

    # converts line breaks in product description into <p> tags (for html display purposes)
    def product_short_description(product)
        if Spree::Config[:show_raw_product_description] || product_wysiwyg_editor_enabled?
            product.short_description
        else
            product.short_description.to_s.gsub(/(.*?)\r?\n\r?\n/m, '<p>\1</p>')
        end
    end
end	
