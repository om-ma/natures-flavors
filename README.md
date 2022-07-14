# Postgres (local database)
psql postgres
postgres=# \du
CREATE USER postgres WITH SUPERUSER PASSWORD 'password';


# Integrate extensions
spree_admin_roles_and_access (DONE)
spree_analytics_trackers (DONE)
spree_admin_insights (DONE)
spree_contact_us (DONE)
spree_events_tracker (DONE)
spree-html-invoice (DONE)
spree_sitemap (DONE)

spree_comments (ISSUES)

spree_mailchimp_ecommerce

bugsnag (NEED TESTING)
scout_apm (NEED TESTING)
spree_shipstation (NEED TESTING)

# Setup

* To setup database
rake db:create (might not need this)
rake db:schema:load
rake db:migrate
rake db:seed
rake spree_roles:permissions:populate
rake spree_roles:permissions:populate_permission_sets

STORE CREDIT ISSUE:
rake db:migrate:down VERSION=20211026070924
rake db:migrate:up VERSION=20211026070924

# Backend Configuration

* Configure Store:
- name = Nature's Flavors (used in migration to look up store)

* Create:
- Option Types: Choose your option, Coffee options, Designs, Subscription, Choose First Extract, Choose Second Extract, Choose Your Food Coloring
- Property: Ingredient Statement
- Shipping Category; Default
- Taxonomy: PRODUCTS (set old_cateogry_id = -1 in db after creation)
- Taxon: set old_cateogry_id = -1 in db for PRODUCTS taxon

* Setup:
- Payment Methods
- Shipping Methods
- Store Credit Categories
- Analytics Trackers
- Comment Types
- Active Shipping Settings
- Stock Locations

* To recreate thumbnails
Spree::Image.all.each do |image| image.create_sizes end

* To generate sitemap manually
- rake sitemap:refresh

* Google Product Feed
update spree_variants set unique_identifier = sku, unique_identifier_type = 'mpn' where is_master = false;
update spree_products set unique_identifier = (select sku from spree_variants where spree_products.id = spree_variants.product_id and spree_variants.is_master = true), unique_identifier_type = 'mpn';
update spree_products set feed_active = true where deleted_at is null;


* Redis
redis-cli (command line)
  Commands:
  - select index (select database)
  - keys * (list all keys)
  - get key (get value)

redis-cli INFO | grep ^db (list databases)


# Generate Doofinder data feed manually
# Can run these locally by setting RAILS_ENV first
export RAILS_ENV=staging
bin/rails r "lib/tasks/doofinder_feed.rb" > "lib/tasks/doofinder_feed_staging.csv"

export RAILS_ENV=production
bin/rails r "lib/tasks/doofinder_feed.rb" > "lib/tasks/doofinder_feed_production.csv"


* Start sidekiq
bundle exec sidekiq -q default -q mailers


# Migration
USERS:
./bin/rails r "migration/users.rb"

PRODUCTS/TAXONS:
gem install thor -v 0.20.3

bundle exec thor datashift_spree:load:products -i "migration/exports/test.csv"

bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export1.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export2.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export3.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export4.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export5.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export6.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export7.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export8.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export9.csv"
bundle exec thor datashift_spree:load:products -i "migration/exports/Natures Flavors PrestaShop-Spree Data Migration - Products IMPORT SPLIT - Export10.csv"

RUN SQLs:
migration/sql/delete_all_taxons_from_old_product_id_57612.sql
migration/sql/do_not_track_inventory
migration/sql/update_meta_data.sql
migration/sql/update_products_properties.sql
migration/sql/update_products_short_descriptions.sql
migration/sql/update_taxons.sql

TERMINAL:
bin/rails r migration/upload_category_images.rb
bin/rails r migration/delete_inactive_taxon.rb
bin/rails r migration/fix_variant_master_price.rb
bin/rails r migration/reorder_variants_by_price.rb


BACKEND:
Reorder taxons in backend
Rename taxon "More Products" to "More"
Delete "Deals" taxon (do not need it statically created)

# Create YotPo products feed. Run in rails console.
YotpoFeedCreator.call(Rails.application.default_url_options)