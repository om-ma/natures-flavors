module Spree
  module UserDecorator

    def self.prepended(base)
    	base.has_many :taxons_users
    	base.has_many :taxons, :through => :taxons_users
    end
  end  
end

::Spree::User.prepend(Spree::UserDecorator)
