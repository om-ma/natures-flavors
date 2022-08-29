# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
  config.products_per_page = 20
  confirmation_required = false

  # Site title
  config.always_put_site_name_in_title = true
  config.title_site_name_separator = "|"
end

# Configure Spree Dependencies
#
# Note: If a dependency is set here it will NOT be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will make the dependency value go away.
#
Spree.dependencies do |dependencies|
  # Example:
  # Uncomment to change the default Service handling adding Items to Cart
  # dependencies.cart_add_item_service = 'MyNewAwesomeService'
end


Spree.user_class = "Spree::User"
Spree::PermittedAttributes.product_attributes << :short_description
Spree::PermittedAttributes.taxon_attributes << [user_ids:[]]
Spree::PermittedAttributes.taxon_attributes << [:short_description, :noindex, :h1_title]
Spree::PermittedAttributes.address_attributes << :is_default
Spree::PermittedAttributes.checkout_attributes << [:request_coa]
Spree::Auth::Config[:registration_step]= false
Spree::PermittedAttributes.source_attributes << :check_no
Spree::SalesConfiguration::Config = Spree::SalesConfiguration.new
Spree::SalesConfiguration::Config.calculators << Spree::Calculator::AmountSalePriceCalculator
Spree::SalesConfiguration::Config.calculators << Spree::Calculator::PercentOffSalePriceCalculator
Spree::PermittedAttributes.payment_attributes << :check_no

# PrestaShop data migration fields
Spree::PermittedAttributes.product_attributes << [:old_product_id, :old_product_url]
Spree::PermittedAttributes.taxon_attributes << [:old_category_id, :old_category_url]
Spree::PermittedAttributes.taxonomy_attributes << [:old_category_id]
Spree::PermittedAttributes.variant_attributes << :old_product_id

# Add production_state field to spree_orders table
Spree::PermittedAttributes.checkout_attributes << :production_state

# Turn off tinymce (Open issue)
Spree::Config.taxon_wysiwyg_editor_enabled = false
Spree::Config.product_wysiwyg_editor_enabled = false

# Prevent split shipments
Rails.application.config.spree.stock_splitters = []