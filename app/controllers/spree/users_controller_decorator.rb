module Spree 
  module UsersControllerDecorator
    def show
      load_object
      @orders                         = @user.orders.complete.order('completed_at desc')
      # @profile_orders                 = @orders.present? ? @orders.first(3) : []
      # @favorite_products              = spree_current_user.favorite_products
      # @favorite_variants              = spree_current_user.favorite_variants
      # @favorite_products_or_variants  = @favorite_products + @favorite_variants
      # @profile_favorite_products      = @favorite_products_or_variants.present? ? @favorite_products_or_variants.first(3) : []
      @user_addresses                 = spree_current_user.present? ? spree_current_user.addresses : []
      @profile_ccs 			              = spree_current_user.present? ? current_spree_user.credit_cards : []
    end
  end
end
::Spree::UsersController.prepend Spree::UsersControllerDecorator if ::Spree::UsersController.included_modules.exclude?(Spree::UsersControllerDecorator)