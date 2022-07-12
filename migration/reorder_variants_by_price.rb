products = Spree::Product.all;

ActiveRecord::Base.logger.level = 1;

if true
  products.each do |p|
    if (p.master.present? && p.variants.present?) then 
      sorted = p.variants_including_master.sort_by { |a| a.is_master ? 0 : 1 }
      first = sorted.shift()
      final_sorted = sorted.sort { |a,b| a.price <=> b.price }
      final = final_sorted.prepend(first)

      final.each.with_index(1) do |v, i|
        v.position = i
        v.save!
      end
    end
  end
end