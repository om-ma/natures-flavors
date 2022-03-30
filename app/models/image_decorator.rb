Spree::Image.class_eval do

  after_save :create_sizes

  def self.styles
    {
      mini: '110x110', # thumbs under image
      slider_preview: '247x247', # thumbnails in product page
      small: '110x110', # side cart images
      product: '360x360', # full product image
      large: '380x380', # product page images
      overview_slider: '380x380' # quickview imagess
    }
  end

  def create_sizes
    Spree::Image.styles.keys.each do |style|
      obj = self.url(style)
      obj.processed
    end
  end

end