module Spree
  module SlideDecorator

  	def my_cf_mobile_image_url
	    default_options = Rails.application.default_url_options
	    ActiveStorage::Current.host = default_options[:host]
	    str = self.slide_mobile_image.url
	    path = str.split('//').last.split("/",2).last
	    Rails.env.development? ? str : ""
	  end

	  def my_cf_desktop_image_url
	    default_options = Rails.application.default_url_options
	    ActiveStorage::Current.host = default_options[:host]
	    str = self.slide_image.url
	    path = str.split('//').last.split("/",2).last
	    Rails.env.development? ? str : ""
	  end
  end
end

::Spree::Slide.prepend(Spree::SlideDecorator)