module Spree
  module TaxonDecorator

    def self.prepended(base)
    	base.has_many :taxons_users
    	base.has_many :users, :through => :taxons_users
    end

    def is_top_level_menu_item
      root_products_taxon = Spree::Taxon.find_by_name("PRODUCTS")
      return (parent.present? && parent == root_products_taxon)
    end

  end  
end

::Spree::Taxon.prepend(Spree::TaxonDecorator)
