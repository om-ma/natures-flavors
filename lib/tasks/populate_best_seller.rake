namespace :populate_best_seller do
  desc "Populate total_units_sold for products"
  task populate_sold_counts: :environment do
    Spree::Product.all.each do |product|
      total_units_sold = Spree::LineItem.joins(:order)
        .where("spree_orders.state = 'complete' AND spree_line_items.variant_id IN (?)", product.variants.pluck(:id))
        .sum(:quantity)
      
      product.update(total_units_sold: total_units_sold) if total_units_sold > 0
    end

    puts "Total units sold populated for products with positive total_units_sold."
  end
end
