class DoofinderCacheWorker
  include Sidekiq::Worker

  def perform()
    Spree::Product.all.where(discontinue_on: nil).each do |product|
      Spree::Product.yotpo_find_cached_by_id(product.id)
    end
  end

end