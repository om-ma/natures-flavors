class TaxonImageCreateSizesWorker
  include Sidekiq::Worker

  def perform(image_id)
    Spree::TaxonImage.where(id: image_id)&.first.create_sizes
  end

end