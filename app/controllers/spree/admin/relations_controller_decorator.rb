Spree::Admin::RelationsController.class_eval do
  include Spree::Admin::CacheConcern
    
  after_action :clear_cache

  def clear_cache
    clear_views_product_cache(@relation.relatable)
  end

end
