Spree::Admin::ProductsController.class_eval do
  include Spree::Admin::CacheConcern
  
  update.after :clear_views_product_cache
end
