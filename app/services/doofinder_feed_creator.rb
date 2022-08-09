class DoofinderFeedCreator < ApplicationService
  CACHED_KEY = "#{ENV['DOOFINDER_FEED_CACHED_KEY']}"
  FEED_FILE_NAME = "doofinder-feed.csv"

  def initialize(url_options, refresh, write_to_aws_s3 = false)
    @url_options = url_options
    @refresh = refresh # ignore for write_to_aws_s3
    @write_to_aws_s3 = write_to_aws_s3
  end

  def call()
    if @write_to_aws_s3
      generate_feed_file()
      upload_to_s3()
    else
      if @refresh
        Rails.cache.write(
          CACHED_KEY, 
          generate(),
          expires_in: 24.hours
        )
      else
        Rails.cache.fetch(CACHED_KEY, expires_in: 24.hours) do
          generate()
        end
      end
    end
  end

  private

  def generate_feed_file()
    file = File.new("./tmp/#{FEED_FILE_NAME}", 'w')
    file.sync = true
    file.write("id|title|link|description|meta_title|meta_description|price|image_link|categories|mpn\r\n")

    @products = Spree::Product.active.distinct
    @products.each_with_index do |product, index|
      if product.is_in_hide_from_nav_taxon?
        next
      end

      description = ""
      if product.short_description.present?
        description = product.short_description.gsub(/\s+/, ' ').strip
      elsif product.description.present?
        description = product.description.gsub(/\s+/, ' ').strip
      end

      categories = doofinder_categories(product)

      file.write(product.id)
      file.write('|')
      file.write(product.name)
      file.write('|')
      file.write(product_url(product))
      file.write('|')
      file.write(description)
      file.write('|')
      file.write(product.meta_title)
      file.write('|')
      file.write(product.meta_description)
      file.write('|')
      file.write(product.master.price)
      file.write('|')
      if product.images.first.nil?
        file.write('')
      else
        file.write(product.images.first.my_cf_image_url("large"))
      end
      file.write('|')
      file.write(categories)
      file.write('|')
      file.write(product.master.sku)
      file.write("\r\n")

      GC.start if index % 100 == 0 # forcing garbage collection
    end

    file.close
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
    bucket_name = "#{ENV['S3_DOOFINDER_FEED_BUCKET']}"
    object_key = FEED_FILE_NAME
    region = "#{ENV['S3_DOOFINDER_FEED_REGION']}"

    s3_client = Aws::S3::Client.new(
      region:            ENV['S3_DOOFINDER_FEED_REGION'],
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

  def generate()
    feed_data = "id|title|link|description|meta_title|meta_description|price|image_link|categories|mpn\r\n"

    @products = Spree::Product.active.distinct
    @products.each do |product|
      if product.is_in_hide_from_nav_taxon?
        next
      end
      
      description = ""
      if product.description.present?
        description = product.description.gsub(/\s+/, ' ').strip
      elsif product.short_description.present?
        description = product.short_description.gsub(/\s+/, ' ').strip
      end

      categories = doofinder_categories(product)
      
      feed_data << "#{product.master.sku}|#{product.name}|#{product_url(product)}|#{description}|#{product.meta_title}|#{product.meta_description}|#{product.master.price}|#{product.images.first.my_cf_image_url("large")}|#{categories}|#{product.master.sku}\r\n"
    end

    feed_data
  end

  def product_url(product)
    url = @url_options[:host]
    url = url + ":" + @url_options[:port].to_s if @url_options[:port]
    url = url + "/products/" + product.slug
    url
  end

end