Spree::Admin::VariantsController.class_eval do
  include Spree::Admin::CacheConcern

  after_action :clear_views_product_cache
end
