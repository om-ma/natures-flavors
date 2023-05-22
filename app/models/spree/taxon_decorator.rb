module Spree
  module TaxonDecorator

    def self.prepended(base)
    	base.has_many :taxons_users
    	base.has_many :users, :through => :taxons_users
      base.has_many :promotion_rule_taxons_option_value, class_name: 'Spree::PromotionRuleTaxonOptionValue', dependent: :destroy
    end

    def is_top_level_menu_item
      root_products_taxon = Spree::Taxon.find_by_name("PRODUCTS")
      return (parent.present? && parent == root_products_taxon)
    end

  end  
end

::Spree::Taxon.prepend(Spree::TaxonDecorator)
