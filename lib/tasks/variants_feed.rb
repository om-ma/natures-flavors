# INSTRUCTIONS: Set RAILS_ENV

# export RAILS_ENV=development
# bin/rails r "lib/tasks/products_feed.rb" > "lib/tasks/variants_feed_development.csv"

# export RAILS_ENV=staging
# bin/rails r "lib/tasks/products_feed.rb" > "lib/tasks/variants_feed_staging.csv"

# export RAILS_ENV=production
# bin/rails r "lib/tasks/products_feed.rb" > "lib/tasks/variants_feed_production.csv"

if Rails.env.development?
  root_url = "http://naturesflavors.localhost:3000/products"
elsif Rails.env.staging?
  root_url = "https://naturesflavors.naturlax.org/products"
elsif Rails.env.production?
  root_url = "https://www.naturesflavors.com/products"
end

puts "variant_id|product_id|name|sku|weight|is_master|categories"
@products = Spree::Product.active.distinct.order(:name)
@products.each do |product|
  categories = doofinder_categories(product)
  
  variants = product.variants_including_master
  variants.each do |variant|
    puts "#{variant.id}|#{product.id}|#{product.name}|#{variant.sku}|#{variant.weight}|#{variant.is_master}|#{categories}"
  end
end