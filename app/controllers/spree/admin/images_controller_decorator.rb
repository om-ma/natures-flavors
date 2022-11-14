Spree::Admin::ImagesController.class_eval do
  include Spree::Admin::CacheConcern

  if Rails.configuration.x.cache.images_backend_clear_on_update == 'true'
    after_action :clear_views_product_cache
  end
end
