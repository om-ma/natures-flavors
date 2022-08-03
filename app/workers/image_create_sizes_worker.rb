class ImageCreateSizesWorker
  include Sidekiq::Worker

  def perform(image_id)
    Spree::Image.where(id: image_id)&.first.create_sizes
  end

end