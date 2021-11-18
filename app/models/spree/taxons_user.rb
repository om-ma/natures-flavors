module Spree
  class TaxonsUser < Spree::Base
    belongs_to :taxon
  	belongs_to :user
  end
end