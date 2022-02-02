module Spree
  module AddressDecorator
    def self.prepended(base)
      base.attr_accessor :is_address_save
      base.scope :defaults, -> {where(is_default: true) }
    end
  end
end

::Spree::Address.prepend(Spree::AddressDecorator)