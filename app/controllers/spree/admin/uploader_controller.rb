
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

        render json: {location: get_url(blob)}, content_type: "text/html"
      end

      def get_url(blob)
        if Rails.env.development?
          main_app.rails_blob_url(blob)
        else
          path = blob.url.split('//').last.split("/",2).last
          ""
        end
      end
    end
  end
end