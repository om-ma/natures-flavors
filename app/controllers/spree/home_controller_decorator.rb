Spree::HomeController.class_eval do
  def index
    @best_sellers_category = Spree::Taxon.find_by_name("Bestsellers").present? ? Spree::Taxon.find_by_name("Bestsellers") : ''
    @best_sellers_products = @best_sellers_category.present? ? @best_sellers_category.products.first(6) : []
    @Deals = Spree::Taxon.find_by_name("Deals").present? ? Spree::Taxon.find_by_name("Deals") : ''
    @Deals_products= @Deals.present? ? @Deals.products.first(6) : [] 
    @Popular_extracts = Spree::Taxon.find_by_name("Popular Extracts").present? ? Spree::Taxon.find_by_name("Popular Extracts") : ''
    @Popular_extracts_products= @Popular_extracts.present? ?  @Popular_extracts.products.first(6) : [] 
    @Popular_Powders = Spree::Taxon.find_by_name("Popular Powders").present? ? Spree::Taxon.find_by_name("Popular_Powders") : ''
    @Popular_Powders_products=@Popular_Powders.present? ? @Popular_Powders.products.first(6) : [] 
    @Popular_oils = Spree::Taxon.find_by_name("Popular Oils").present? ? Spree::Taxon.find_by_name("Popular Oils") : ''
    @Popular_oils_products=@Popular_oils.present? ? @Popular_oils.products.first(6) : [] 
  end
end