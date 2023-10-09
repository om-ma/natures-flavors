Spree::CacheHelper.module_eval do

  def cache_key_for_mobile
    mobile = browser.device.mobile?
    "mobile/#{mobile}"
  end

  def cache_key_for_tablet
    tablet = browser.device.mobile?
    "tablet/#{tablet}"
  end

  def cache_key_for_all_categories(all_categories = @all_categories, additional_cache_key = nil)
    max_updated_at = (all_categories.except(:group, :order).maximum(:updated_at) || Date.today).to_s(:number)
    "spree/all_categories/#{all_categories.map(&:id).join('-')}-#{max_updated_at}"
  end
  
  def cache_key_for_all_categories_without_version(all_categories = @all_categories, additional_cache_key = nil)
    "spree/all_categories/#{all_categories.map(&:id).join('-')}"
  end

  def cache_key_for_products_without_version(products = @products, taxon = @taxon, additional_cache_key = nil)
    if products.present?
      count = products.length
      products_cache_keys = "spree/products/#{products.map(&:id).join('-')}-#{params[:page]}-#{params[:sort_by]}-#{taxon&.id}-#{count}"
    else
      products_cache_keys = "spree/products/nil-#{params[:page]}-#{params[:sort_by]}-#{taxon&.id}"
    end
    (common_product_cache_keys + [products_cache_keys] + [additional_cache_key]).compact.join('/')
  end

  def cache_key_for_product_wihtout_version(product = @product)
    product.cache_key
  end

  def cache_key_for_slider(slide)
    "slider/slides/#{slide&.id}"
  end

  def cache_key_for_home_index(all_categories = @all_categories, home_slides = @home_slides, best_sellers_products = @best_sellers_products, deals_products = @deals_products, popular_extracts_products = @popular_extracts_products, popular_powders_products = @popular_powders_products, popular_oils_products = @popular_oils_products)
    mobile_cache_key                     = cache_key_for_mobile
    tablet_cache_key                     = cache_key_for_tablet
    all_categories_cache_keys            = cache_key_for_all_categories_without_version(all_categories)
    home_top_cache_keys = []
    home_middle_cache_keys = []
    
    (1..8).each do |number|
      current_top_slide = instance_variable_get("@top_#{number}_slide").first
      home_top_cache_keys << cache_key_for_slider(current_top_slide)
    end
    
    (1..5).each do |number|
      current_middle_slide = instance_variable_get("@middle_#{number}_slide").first
      home_middle_cache_keys << cache_key_for_slider(current_middle_slide)
    end

    best_sellers_products_cache_keys     = cache_key_for_best_sellers(best_sellers_products)
    deals_products_cache_keys            = cache_key_for_products_without_version(deals_products)
    popular_extracts_products_cache_keys = cache_key_for_products_without_version(popular_extracts_products)
    popular_powders_products_cache_keys  = cache_key_for_products_without_version(popular_powders_products)
    popular_oils_products_cache_keys     = cache_key_for_products_without_version(popular_oils_products)
    ([mobile_cache_key] + [tablet_cache_key] + [all_categories_cache_keys] + home_top_cache_keys + home_middle_cache_keys + [best_sellers_products_cache_keys] + [deals_products_cache_keys] + [popular_extracts_products_cache_keys] + [popular_powders_products_cache_keys] + [popular_oils_products_cache_keys]).compact.join('/')
  end

  def cache_key_for_taxon_show(all_categories = @all_categories, products = @products)
    mobile_cache_key    = cache_key_for_mobile
    tablet_cache_key    = cache_key_for_tablet
    all_categories_cache_keys = cache_key_for_all_categories_without_version(all_categories)
    products_cache_keys       = cache_key_for_products_without_version(products)
    ([mobile_cache_key] + [tablet_cache_key] + [all_categories_cache_keys] + [products_cache_keys]).compact.join('/')
  end

  def cache_key_for_taxon_show_top_level_subcategories(products = @products, taxon = @taxon)
    mobile_cache_key    = cache_key_for_mobile
    tablet_cache_key    = cache_key_for_tablet
    products_cache_keys = cache_key_for_products_without_version(products)
    ([mobile_cache_key] + [tablet_cache_key] + [products_cache_keys]).compact.join('/')
  end

  def cache_key_for_best_sellers_product(product = @product)
    "spree/best_seller_product/for/product/id/#{product.id}"
  end

  def cache_key_for_related_product(product = @product)
    "spree/relates_products/for/product/id/#{product.id}"
  end

  def cache_key_for_product_by_friendly_url(slug)
    "spree/product/by/friendly/url/#{slug}"
  end

  def cache_key_for_variants(product = @product)
    "spree/variants/for/product/id/#{product.id}"
  end
  
end
