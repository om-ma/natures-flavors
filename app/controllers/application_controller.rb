class ApplicationController < ActionController::Base
	before_action :set_categories

	private

	def set_categories
		product_category	= Spree::Taxon.find_by_name("PRODUCTS")
		@all_categories   = product_category.present? ? product_category&.children : []
	end
end
