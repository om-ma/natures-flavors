class ApplicationController < ActionController::Base
	before_action :set_categories

	private

	def set_categories
		@main_category	= Spree::Taxon.first
	end
end
