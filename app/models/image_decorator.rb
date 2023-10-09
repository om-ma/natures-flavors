Spree::Image.class_eval do

  after_save :call_create_sizes_worker
  
  # Use sidekiq worker to create images. Transaction issue.
  def call_create_sizes_worker
    ImageCreateSizesWorker.perform_async(self.id)
  end

  def create_sizes
    Spree::Image.styles.keys.each do |style|
      obj = self.url(style)
      obj.processed
    end
  end

  def my_cf_image_url(style)
    default_options = Rails.application.default_url_options
    ActiveStorage::Current.host = default_options[:host]
    
    my_url = self.url(style)
    if (my_url.is_a? String)
      str = my_url
    else
      str = my_url.url
    end

    path = str.split('//').last.split("/",2).last
    Rails.env.development? ? str : ""
  end

end