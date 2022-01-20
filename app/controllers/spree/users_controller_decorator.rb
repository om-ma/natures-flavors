module Spree 
    module UsersControllerDecorator
      def show
        load_object
        favorite_products = spree_current_user.favorite_products
        @favorite_products= favorite_products.present? ? favorite_products.last(3) : []
      end
    end
  end
  ::Spree::UsersController.prepend Spree::UsersControllerDecorator if ::Spree::UsersController.included_modules.exclude?(Spree::UsersControllerDecorator) 
  