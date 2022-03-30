Spree::Image.class_eval do

  after_save :create_sizes

  def self.styles
    {
      large: '1000x1000', # product page images
    }
  end

  def create_sizes
    Spree::Image.styles.keys.each do |style|
      obj = self.url(style)
      obj.processed
    end
  end

end