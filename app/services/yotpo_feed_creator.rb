class YotpoFeedCreator < ApplicationService
  FEED_FILE_NAME = "yotpo-feed.csv"

  def initialize(url_options)
    @url_options = url_options
  end

  def call()
    generate_feed_file()
  end

  private

  def generate_feed_file()
    file = File.new("./tmp/#{FEED_FILE_NAME}", 'w')
    file.sync = true
    file.write("Product ID,Product Name,Product Description,Product URL,Product Image URL,Product Price,Currency,Spec SKU,Spec Brand,Spec MPN,Blacklisted\r\n")

    @products = Spree::Product.active.distinct
    @products.each_with_index do |product, index|
      if product.is_in_hide_from_nav_taxon?
        next
      end
      
      description = ""
      # Combine descriptions
      if product.short_description.present?
        description = product.short_description.gsub(/\s+/, ' ').strip
        description = description.gsub('"', '""')
      end
      if product.description.present?
        description = description + product.description.gsub(/\s+/, ' ').strip
        description = description.gsub('"', '""')
      end

      file.write(product.id)
      file.write(',')
      file.write('"', product.name, '"')
      file.write(',')
      file.write('"', description, '"')
      file.write(',')
      file.write(product_url(product))
      file.write(',')
      if product.images.first.nil?
        file.write('')
      else
        file.write(product.images.first.my_cf_image_url("large"))
      end
      file.write(',')
      file.write(product.master.price)
      file.write(',')
      file.write('USD')
      file.write(',')
      file.write(product.master.sku)
      file.write(',')
      file.write('Nature\'s Flavors')
      file.write(',')
      file.write(product.master.sku)
      file.write(',')
      file.write('false')
      file.write("\r\n")

      GC.start if index % 100 == 0 # forcing garbage collection
    end
    
    file.close
  end

  def product_url(product)
    url = @url_options[:host]
    url = url + ":" + @url_options[:port].to_s if @url_options[:port]
    url = url + "/products/" + product.slug
    url
  end

end