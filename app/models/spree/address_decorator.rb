module Spree
  module AddressDecorator
    def self.prepended(base)
      base.attr_accessor :is_address_save
      base.scope :defaults, -> {where(is_default: true) }
      base.before_save :clear_other_is_default
    end

    def clear_other_is_default
      if is_default && user.present?
        Spree::Address.where.not(id: id).where(user_id: 1, is_default: true, deleted_at: nil).each do |address|
          address.is_default = false
          address.save!
        end
      end
    end
  end
end

::Spree::Address.prepend(Spree::AddressDecorator)