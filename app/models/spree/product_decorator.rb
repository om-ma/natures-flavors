module Spree
    module ProductDecorator
  
      def self.prepended(base)
          # base.scope :is_new, -> { where(is_new: true) }
          base.scope :best_sellers, -> { active.select("spree_products.*, SUM(spree_line_items.quantity) as total_qty, spree_line_items.variant_id").
                  joins(:line_items).joins("INNER JOIN spree_orders ON spree_orders.id = spree_line_items.order_id").
                  where("spree_orders.state = 'complete'").
                  group("spree_line_items.variant_id, spree_products.id").order("total_qty DESC")}
      end
    end  
  end
  
  ::Spree::Product.prepend(Spree::ProductDecorator)