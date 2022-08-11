class DoofinderCacheWorker
  include Sidekiq::Worker

  def perform()
    Spree::Product.all.where(discontinue_on: nil).each do |product|
      Spree::Product.doofinder_cache_find(product.id)
    end
  end

end