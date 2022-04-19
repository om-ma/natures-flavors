module Spree 
  module UserSessionsControllerDecorator
    def self.prepended(base)
      base.before_action :is_redirect_to_checkout, only: :new
    end

    def is_redirect_to_checkout
      if request.referer.include?("checkout")
        session["spree_user_return_to"] = spree.checkout_state_path("address")
      else
         session["spree_user_return_to"] = request.referer
      end
    end
  end
end    
::Spree::UserSessionsController.prepend Spree::UserSessionsControllerDecorator if ::Spree::UserSessionsController.included_modules.exclude?(Spree::UserSessionsControllerDecorator)  