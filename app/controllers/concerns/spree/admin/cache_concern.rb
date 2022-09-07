module Spree
  module Admin
    module CacheConcern
      extend ActiveSupport::Concern

      include Spree::FrontendHelper
      include Spree::ProductsHelper

      def clear_views_product_cache(product = @product)
        views = [
          'views/spree/products/_cart_form',
          'views/spree/products/_overview_tabs',
          'views/spree/products/_phone_cart_form',
          'views/spree/products/_product',
          'views/spree/products/_related_product',
          'views/spree/products/_search_product',
          'views/spree/products/show',
          'views/spree/shared/_product',
          'views/spree/shared/_sale_product'
        ]
        views.each { |view|
          keys = "#{view}*#{cache_key_for_product_wihtout_version(product)}"
          Rails.cache.delete_matched(keys)
        } 
      end

    end
  end
end
