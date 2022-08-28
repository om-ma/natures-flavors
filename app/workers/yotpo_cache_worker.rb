class YotpoCacheWorker
  include Sidekiq::Worker

  def perform()
    Spree::Product.all.where(discontinue_on: nil).each do |product|
      product.yotpo_rich_snippets(true)
      product.yotpo_reviews(true)

      # Build product cache for search JSON results
      Spree::Product.find_cached_by_id(product.id, true)
    end
  end

end