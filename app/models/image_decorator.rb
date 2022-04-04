Spree::Image.class_eval do

  after_save :create_sizes

  def self.styles
    {
      small: '180x180',
      product: '1000x1000',
      large: '1000x1000', # product page images
    }
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
    str = self.url(style).service_url
    path = str.split('//').last.split("/",2).last
    Rails.env.development? ? str : "https://#{ENV['CLOUDFRONT_ASSET_URL']}/#{path}"
  end

end