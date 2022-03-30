# Setup

* To setup database
rake db:create (might not need this)
rake db:schema:load
rake db:migrate
rake db:seed
#rake spree_roles:permissions:populate
#rake spree_roles:permissions:populate_permission_sets


* To recreate thumbnails
Spree::Image.all.each do |image| image.create_sizes end


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
