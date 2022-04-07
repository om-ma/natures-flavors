Spree::Image.class_eval do

  #after_save :create_sizes

  def self.styles
    {
      mini: '48x48>',
      small: '180x180>',
      product: '240x240>',
      pdp_thumbnail: '180x180>',
      plp_and_carousel: '448x600>',
      plp_and_carousel_xs: '180x180>',
      plp_and_carousel_sm: '180x180>',
      plp_and_carousel_md: '180x180>',
      plp_and_carousel_lg: '240x240>',
      large: '1000x1000>',
      plp: '240x240>',
      zoomed: '1000x1000>'
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