class YotpoMappingCreator < ApplicationService
  MAPPING_FILE_NAME = "yotpo-naturesflavors-products-mapping.csv"

  def initialize(url_options)
    @url_options = url_options
  end

  def call()
    generate_feed_file()
  end

  private

  def generate_feed_file()
    file = File.new("./tmp/#{MAPPING_FILE_NAME}", 'w')
    file.sync = true
    file.write("product_id,product_url,product_title,product_image_url,new_product_id,new_product_url,new_product_title,new_product_image_url\r\n")

    @products = Spree::Product.active.distinct
    @products.each_with_index do |product, index|
      file.write(product.old_product_id)
      file.write(',')
      file.write(',')
      file.write(',')
      file.write(',')
      file.write(product.id)
      file.write(',')
      file.write(product_url(product))
      file.write(',')
      file.write('"', product.name, '"')
      file.write(',')
      if product.images.first.nil?
        file.write('')
      else
        file.write(product.images.first.my_cf_image_url("large"))
      end
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