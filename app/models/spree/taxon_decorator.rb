module Spree
  module TaxonDecorator

    def self.prepended(base)
    	base.has_many :taxons_users
    	base.has_many :users, :through => :taxons_users
    end
  end  
end

::Spree::Taxon.prepend(Spree::TaxonDecorator)
