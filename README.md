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
