Spree::HomeController.class_eval do
  def index
    best_sellers_category = Spree::Taxon.find_by_name("Bestsellers").present? ? Spree::Taxon.find_by_name("Bestsellers") : ''
    @best_sellers_products = best_sellers_category.present? ? best_sellers_category.products.first(6) : []
    deals = Spree::Taxon.find_by_name("Deals").present? ? Spree::Taxon.find_by_name("Deals") : ''
    @deals_products= deals.present? ? deals.products.first(6) : [] 
    popular_extracts = Spree::Taxon.find_by_name("Popular Extracts").present? ? Spree::Taxon.find_by_name("Popular Extracts") : ''
    @popular_extracts_products= popular_extracts.present? ?  popular_extracts.products.first(6) : [] 
    popular_Powders = Spree::Taxon.find_by_name("Popular Powders").present? ? Spree::Taxon.find_by_name("Popular_Powders") : ''
    @popular_Powders_products= popular_Powders.present? ? popular_Powders.products.first(6) : [] 
    popular_oils = Spree::Taxon.find_by_name("Popular Oils").present? ? Spree::Taxon.find_by_name("Popular Oils") : ''
    @popular_oils_products= popular_oils.present? ? popular_oils.products.first(6) : [] 
  end
end