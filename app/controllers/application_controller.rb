class ApplicationController < ActionController::Base
	include Pagy::Backend

	before_action :set_categories
	
	private

	def set_categories
		@product_category = Rails.cache.fetch("@product_category", expires_in: Rails.configuration.x.cache.expiration) do
			Spree::Taxon.includes(children: :taxons_users).references(children: :taxons_users).find_by_name("PRODUCTS")
		end

		@all_categories = Rails.cache.fetch("@all_categories", expires_in: Rails.configuration.x.cache.expiration) do
			(@product_category.present? ? @product_category&.children.where(hide_from_nav: false).order(:position): [])
		end

		if spree_current_user.present?
			@all_special_categories = (@product_category.present? ? @product_category&.children.where(hide_from_nav: true).order(:position): [])
			@special_catetories = []
			if @all_special_categories.present?
				if spree_current_user.has_spree_role?('employee')
					@special_catetories = @all_special_categories
				else
					@all_special_categories.each { |category|
						@special_catetories.push(category) if category.users.include?(spree_current_user)
					}
				end
			end
		end
	end

	def default_url_options
    Rails.application.default_url_options
  end
end
