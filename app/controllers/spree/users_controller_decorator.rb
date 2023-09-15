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

      def update
        load_object
        
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end

        if @user.update(user_params)
          if params[:user][:password].present?
            # this logic needed b/c devise wants to log us out after password changes
            Spree.user_class.reset_password_by_token(params[:user])
            if Spree::Auth::Config[:signout_after_password_change]
              sign_in(@user, event: :authentication)
            else
              bypass_sign_in(@user)
            end
          end
          redirect_to spree.account_path, notice: Spree.t(:account_updated)
        else
          render :edit
        end
      end
      
    end
  end
::Spree::UsersController.prepend Spree::UsersControllerDecorator if ::Spree::UsersController.included_modules.exclude?(Spree::UsersControllerDecorator) 
  
