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
Users:
bin/rails r "migration/users.rb"

Products/Categories:
gem install thor -v 0.20.3
bundle exec thor datashift_spree:load:products -i "migration/Natures Flavors Data Export - Export1.csv"
bundle exec thor datashift_spree:load:products -i "migration/Natures Flavors Data Export - Export2.csv"
...

Run:
migration/sql/update_taxon.sql
