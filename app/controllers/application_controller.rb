class ApplicationController < ActionController::Base
	include Pagy::Backend

	before_action :set_categories
	before_action :set_best_sellers
	before_action :product_sale_exists
	before_action :is_user_employee
	
	private

	def set_categories
		@product_category = Rails.cache.fetch("@product_category", expires_in: Rails.configuration.x.cache.expiration, race_condition_ttl: 30.seconds) do
			Spree::Taxon.includes(children: :taxons_users).references(children: :taxons_users).find_by_name("PRODUCTS")
		end

		@all_categories = Rails.cache.fetch("@all_categories", expires_in: Rails.configuration.x.cache.expiration, race_condition_ttl: 30.seconds) do
			(@product_category.present? ? @product_category&.children.where(hide_from_nav: false).order(:position): [])
		end

		ActiveRecord::Base.connected_to(role: :writing) do
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
	end

	def set_best_sellers
		@best_sellers_products_sample = Rails.cache.fetch("@best_sellers_products_sample", expires_in: Rails.configuration.x.cache.expiration, race_condition_ttl: 30.seconds) do
			Spree::Product.best_sellers.present? ? Spree::Product.best_sellers.sample : []
		end
	end

	def product_sale_exists
		@product_sale_exists = Spree::Product.on_sale.exists?
	end

	def is_user_employee
		@is_user_employee = spree_current_user.present? && spree_current_user.has_spree_role?('employee')
	end

	def default_url_options
    Rails.application.default_url_options
  end
end
