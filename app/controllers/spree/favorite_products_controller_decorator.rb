module Spree
  module FavoriteProductsControllerDecorator 
    def self.prepended(base)
      base.before_action :set_favourite_product, only: [:create, :destroy]
    end
    def set_favourite_product
      @favourite_product = Spree::Product.find_by_id params[:id]
    end
    def destroy
      @success = @favorite.destroy
      respond_to do |format|
        format.html { redirect_back_or_default(account_path) }
        format.js
      end
    end
  end
end
::Spree::FavoriteProductsController.prepend Spree::FavoriteProductsControllerDecorator