module Spree 
    module UsersControllerDecorator
      def show
        load_object
        @favorite_products = spree_current_user.favorite_products
        @orders           = @user.orders.complete.order('completed_at desc')
        @user_addresses  = spree_current_user.present? ? spree_current_user.addresses : []
        
        authorize_net_cim_payment_method = Spree::PaymentMethod.find_by_type('Spree::Gateway::AuthorizeNetCim')
        @profile_ccs 	 = spree_current_user.present? ? current_spree_user.credit_cards.where(payment_method: authorize_net_cim_payment_method) : []
      end
    end
  end
::Spree::UsersController.prepend Spree::UsersControllerDecorator if ::Spree::UsersController.included_modules.exclude?(Spree::UsersControllerDecorator) 
  
