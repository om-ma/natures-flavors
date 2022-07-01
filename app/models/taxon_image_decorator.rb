Spree::TaxonImage.class_eval do

  def my_cf_image_url()
    default_options = Rails.application.default_url_options
    ActiveStorage::Current.host = default_options[:host]
    str = self.attachment.url
    path = str.split('//').last.split("/",2).last
    Rails.env.development? ? str : "https://#{ENV['CLOUDFRONT_ASSET_URL']}/#{path}"
  end

end