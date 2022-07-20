class ApplicationController < ActionController::Base
	before_action :set_categories, :set_speciality_categories

	SPECIALITY_TAXON_NAME = 'Specialty'

	private

	def set_categories
		@all_categories = Rails.cache.fetch("@all_categories", expires_in: Rails.configuration.x.cache.expiration) do
			@product_category	= Spree::Taxon.includes(children: :taxons_users).references(children: :taxons_users).find_by_name("PRODUCTS")
			(@product_category.present? ? @product_category&.children.where.not(name: SPECIALITY_TAXON_NAME).order(:position): [])
		end
	end

	def set_speciality_categories
		if spree_current_user.present?
			@all_specialty_categories = Spree::Taxon.find_by_name(SPECIALITY_TAXON_NAME)
			@specialty_catetories = (@all_specialty_categories.present? ? @all_specialty_categories&.children.users.include?(spree_current_user)&.order(:position): [])
		end
	end

	def default_url_options
    Rails.application.default_url_options
  end
end
