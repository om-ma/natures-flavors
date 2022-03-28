module Spree 
    module UsersControllerDecorator
      def show
        load_object
        @favorite_products = spree_current_user.favorite_products
        @orders           = @user.orders.complete.order('completed_at desc')
        @user_addresses  = spree_current_user.present? ? spree_current_user.addresses : []
        @profile_ccs 	 = spree_current_user.present? ? current_spree_user.credit_cards : []
      end
    end
  end
::Spree::UsersController.prepend Spree::UsersControllerDecorator if ::Spree::UsersController.included_modules.exclude?(Spree::UsersControllerDecorator) 
  
