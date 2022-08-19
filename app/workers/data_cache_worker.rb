class DataCacheWorker
  include Sidekiq::Worker

  def perform()
    top_level_taxons = Spree::Taxon.find_by_name("PRODUCTS").children.where(hide_from_nav: false)

    top_level_taxons.each do |taxon|
      products = taxon.products.includes(:product_properties, :prices, :sale_prices).references(:product_properties, :prices, :sale_prices).reorder(popularity: :desc).first(6)
      Rails.cache.write("@pmost-popular-products/taxon/#{taxon.name}", products, expires_in: Rails.configuration.x.cache.expiration)
    end
  end

end