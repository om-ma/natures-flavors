class ApplicationController < ActionController::Base
	before_action :set_categories

	STARTS_WITH_SPECIAL = 'Special'

	private

	def set_categories
		@product_category = Rails.cache.fetch("@product_category", expires_in: Rails.configuration.x.cache.expiration) do
			Spree::Taxon.includes(children: :taxons_users).references(children: :taxons_users).find_by_name("PRODUCTS")
		end

		@all_categories = Rails.cache.fetch("@all_categories", expires_in: Rails.configuration.x.cache.expiration) do
			(@product_category.present? ? @product_category&.children.where.not("lower(name) LIKE '#{STARTS_WITH_SPECIAL.downcase}%'").order(:position): [])
		end

		if spree_current_user.present?
			@all_special_categories = (@product_category.present? ? @product_category&.children.where("lower(name) LIKE '#{STARTS_WITH_SPECIAL.downcase}%'").order(:position): [])
			@special_catetories = []
			if @all_special_categories.present?
				@all_special_categories.each { |category|
					@special_catetories.push(category) if category.users.include?(spree_current_user)
				}
			end
		end
	end

	def default_url_options
    Rails.application.default_url_options
  end
end
