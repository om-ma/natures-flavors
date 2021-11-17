module Spree
	module ProductsControllerDecorator
		def index
			redirect_to page_not_found_path
		end
	end
end
::Spree::ProductsController.prepend Spree::ProductsControllerDecorator