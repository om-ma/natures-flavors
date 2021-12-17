module Spree
	module VariantDecorator
		def size_options
			size_id = Spree::OptionType.where('name ILIKE ?','%size%').first.try(:id)
			self.option_values.where(option_type_id: size_id).first
		end
	end
end
::Spree::Variant.prepend(Spree::VariantDecorator)
