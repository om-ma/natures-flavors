Spree::Image.class_eval do

  after_save :create_sizes

  def self.styles
    {
      mini: '48x48>',
      small: '100x100>',
      product: '240x240>',
      pdp_thumbnail: '160x200>',
      plp_and_carousel: '448x600>',
      plp_and_carousel_xs: '254x340>',
      plp_and_carousel_sm: '350x468>',
      plp_and_carousel_md: '222x297>',
      plp_and_carousel_lg: '278x371>',
      large: '1000x1000>',
      plp: '278x371>',
      zoomed: '650x870>',
      large: '1000x1000' # product page images
    }
  end

  def create_sizes
    Spree::Image.styles.keys.each do |style|
      obj = self.url(style)
      obj.processed
    end
  end

end