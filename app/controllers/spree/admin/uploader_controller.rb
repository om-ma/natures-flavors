
module Spree
  module Admin
    class UploaderController < Spree::Admin::BaseController
      skip_forgery_protection

      def image
        blob = ActiveStorage::Blob.create_and_upload!(
          io:           params[:file],
          filename:     params[:file].original_filename,
          content_type: params[:file].content_type
        )

        render json: {location: cdn_url(main_app.rails_blob_url(blob))}, content_type: "text/html"
      end

      def cdn_url(str)
        path = str.split('//').last.split("/",2).last
        Rails.env.development? ? str : "https://#{ENV['CLOUDFRONT_ASSET_URL']}/#{path}"
      end
    end
  end
end