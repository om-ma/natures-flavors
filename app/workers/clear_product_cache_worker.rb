class ClearProductCacheWorker
  include Sidekiq::Worker
  include Spree::Admin::CacheConcern

  def perform(product_id)
    clear_views_product_cache(load_product(product_id))
  end

  def load_product(id)
    Spree::Product.find_by(slug: id)
  end
end