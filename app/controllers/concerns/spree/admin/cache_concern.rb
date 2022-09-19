module Spree
  module Admin
    module CacheConcern
      extend ActiveSupport::Concern

      include Spree::FrontendHelper
      include Spree::ProductsHelper

      def clear_views_product_cache(product = @product)
        views_key = [
          "views/spree/products/_cart_form*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/products/_overview_tabs*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/products/_phone_cart_form*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/products/_product*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/products/_related_product*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/products/_search_product*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/products/show*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/shared/_product*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/shared/_products*#{product.id}*",
          "views/spree/shared/_sale_product*#{cache_key_for_product_wihtout_version(product)}*",
          "views/spree/taxons/show*#{product.id}*",
          "views/spree/taxons/_top_level_subcategories*#{product.id}*",
          "views/spree/products/show*#{product.id}*",
          "spree/best_seller_product/for/product/id/#{product.id}",
          "spree/relates_products/for/product/id/#{product.id}",
        ]
        views_key.each { |key|
          Rails.cache.delete_matched(key)
        } 
      end

    end
  end
end
