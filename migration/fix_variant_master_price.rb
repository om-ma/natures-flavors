products = Spree::Product.all;

ActiveRecord::Base.logger.level = 1;

if true
  products.each do |p| 
    if (p.master.present? && p.variants.present?) then 
      master_price = p.master.prices.first
      master_price.amount = p.variants.min_by { |v| v.price }.prices.first.amount
      master_price.save!
    end
  end
end