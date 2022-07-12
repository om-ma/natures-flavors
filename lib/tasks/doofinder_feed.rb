if Rails.env.development?
  root_url = "http://naturesflavors.localhost:3000/products"
elsif Rails.env.staging?
  root_url = "https://naturesflavors.naturlax.org/products"
elsif Rails.env.production?
  root_url = "https://www.naturesflavors.com/products"
end

puts "id|title|link|description|meta_title|meta_description|price|image_link|categories|mpn"
@products = Spree::Product.active.distinct
@products.each do |product|
  url = "#{root_url}/#{product.slug}"
  image_url = product.images.first.present? ? product.images.first.my_cf_image_url(:large) : ""
  
  description = ""
  if product.description.present?
    description = product.description.gsub(/\s+/, ' ').strip
  elsif product.short_description.present?
    description = product.short_description.gsub(/\s+/, ' ').strip
  end
  
  categories = product.taxons.map { |taxon| taxon.name }.join(', ')
  
  puts "#{product.master.sku}|#{product.name}|#{url}|#{description}|#{product.meta_title}|#{product.meta_description}|#{product.master.price}|#{image_url}|#{categories}|#{product.master.sku}"
end
