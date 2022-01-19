module Spree
  module FavoriteProductsControllerDecorator 
    def self.prepended(base)
      base.before_action :set_favourite_product, only: [:create, :destroy]
    end
    def set_favourite_product
      @favourite_product = Spree::Product.find_by_id params[:id]
    end
  end
end
::Spree::FavoriteProductsController.prepend Spree::FavoriteProductsControllerDecorator