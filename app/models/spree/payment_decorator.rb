module Spree
  module PaymentDecorator

    def self.prepended(base)
      base.before_save :assign_check_no, if: -> { payment_method&.type == "Spree::PaymentMethod::Check" }
    end

    def assign_check_no
      if source_attributes.present? && source_attributes[:check_no].present?
        self.check_no = source_attributes[:check_no]
      end
    end

  end  
end

::Spree::Payment.prepend(Spree::PaymentDecorator)