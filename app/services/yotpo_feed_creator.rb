class YotpoFeedCreator < ApplicationService
  FEED_FILE_NAME = "yotpo-feed.csv"

  def initialize(url_options, write_to_aws_s3 = false)
    @url_options = url_options
    @write_to_aws_s3 = write_to_aws_s3
  end

  def call()
    generate_feed_file()

    if @write_to_aws_s3
      upload_to_s3()
    end
  end

  private

  def generate_feed_file()
    file = File.new("./tmp/#{FEED_FILE_NAME}", 'w')
    file.sync = true
    file.write("Product ID,Product Name,Product Description,Product URL,Product Image URL,Product Price,Currency,Spec SKU,Spec Brand,Spec MPN,Blacklisted\r\n")

    @products = Spree::Product.active.distinct
    @products.each_with_index do |product, index|
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

      blacklisted = (product.is_in_hide_from_nav_taxon? ? 'true' : 'false')
      file.write(blacklisted)

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

  def object_uploaded?(s3_client, bucket_name, object_key, file)
    response = s3_client.put_object(
      bucket: bucket_name,
      key: object_key,
      body: file
    )
    if response.etag
      return true
    else
      return false
    end
  rescue StandardError => e
    puts "Error uploading object: #{e.message}"
    return false
  end

  def upload_to_s3()
    bucket_name = ""
    object_key = FEED_FILE_NAME
    region = ""

    s3_client = Aws::S3::Client.new(
      region:            ENV['S3_YOTPO_FEED_REGION'],
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    
    file = File.open("./tmp/#{FEED_FILE_NAME}", 'rb')

    if object_uploaded?(s3_client, bucket_name, object_key, file)
      puts "Object '#{object_key}' uploaded to bucket '#{bucket_name}'."
    else
      puts "Object '#{object_key}' not uploaded to bucket '#{bucket_name}'."
    end

    file.close()
  end

end