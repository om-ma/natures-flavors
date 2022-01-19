module Spree
	class CustomCheckoutController < Spree::StoreController
		def refresh_shopping_cart_bag
			@order = current_order 
		end
	end
end