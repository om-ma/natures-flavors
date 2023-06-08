
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
        
        render json: {location: main_app.rails_blob_url(blob)}, content_type: "text/html"
      end
    end
  end
end
