module Spree
  module ProductDecorator

    def self.prepended(base)
    	# base.scope :is_new, -> { where(is_new: true) }
      base.scope :best_sellers, -> {
        active.where.not(total_units_sold: 0).order(total_units_sold: :desc)
      }
      base.scope :with_variant_sales, -> { joins(variants: :sale_prices).active.uniq }      
    end

    def lowest_sale_price
		sale_prices.active.sort_by(&:value).first
    end

    def lowest_expiry_at
      sale_prices.sort_by(&:end_at).first
    end
    
    def is_in_hide_from_nav_taxon?
      taxons.each do |taxon|
        if taxon.hide_from_nav
          return true
        end
      end
      return false
    end

    # override to exclude master if has_variants?
    def can_supply?
      if has_variants?
        variants.any?(&:can_supply?)
      else
        variants_including_master.any?(&:can_supply?)
      end
    end
  end  
end

::Spree::Product.prepend(Spree::ProductDecorator)