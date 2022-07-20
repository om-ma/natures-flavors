class ApplicationController < ActionController::Base
	before_action :set_categories

	private

	def set_categories
		@all_categories = Rails.cache.fetch("@all_categories", expires_in: Rails.configuration.x.cache.expiration) do
			@product_category	= Spree::Taxon.includes(children: :taxons_users).references(children: :taxons_users).find_by_name("PRODUCTS")
			(@product_category.present? ? @product_category&.children.order(:position): [])
		end
	end

	def default_url_options
    Rails.application.default_url_options
  end
end
