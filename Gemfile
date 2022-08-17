source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.5'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use terser as compressor for JavaScript assets
gem 'terser', '~> 1.1', '>= 1.1.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem "asset_sync"
gem 'aws-sdk', '~> 3'
gem "bugsnag", "~> 6.24", groups: [:staging, :production]
gem 'canonical-rails', github: 'ducl13/canonical-rails'
gem 'dotenv-rails'
gem 'fog', '~> 2.0.0'
gem "fog-aws"
gem "paperclip", "~> 6.1.0"
gem "recaptcha", github: 'ducl13/recaptcha', branch: 'master'
gem 'scout_apm'

#Spree
gem 'spree', '= 4.3'
gem 'spree_common', git: 'https://gitlab.com/duc.lam/spree_common.git', branch: 'master'
gem 'spree_frontend', '= 4.3'
gem 'spree_backend', '= 4.3'
gem 'spree_emails', '= 4.3'
gem 'spree_sample' # dummy data like products, taxons, etc
gem 'spree_admin_insights', github: 'ducl13/spree-admin-insights', branch: 'master'
gem 'spree_admin_roles_and_access', github: 'ducl13/spree_admin_roles_and_access', branch: 'master'
gem 'spree_auth_devise', '~> 4.3' # Devise integration (optional)
gem "spree_comments", github: 'ducl13/spree_comments', branch: 'master'
gem 'spree_contact_us', github: 'ducl13/spree_contact_us', branch: 'naturesflavors'
gem 'spree_gateway', '~> 3.9' # payment gateways eg. Stripe, Braintree (optional)
gem 'spree_favorite_products', git: 'https://gitlab.com/duc.lam/spree_favorite_products.git', branch: 'natures'
gem 'spree_html_invoice', github: 'ducl13/spree-html-invoice', branch: 'master'
gem 'spree_i18n', '~> 5.0' # translation files (optional)
gem 'spree_sales', github: 'ducl13/spree_sales', branch: 'master'
gem 'spree_events_tracker', github: 'ducl13/spree_events_tracker', branch: 'naturesflavors'
gem 'spree_active_shipping', github: 'ducl13/spree_active_shipping', branch: '4-3'
gem 'active_shipping', github: 'ducl13/active_shipping', branch: '4-3'
gem 'spree_shipstation', github: 'ducl13/spree_shipstation-2', branch: 'master'
gem 'spree_sitemap', github: 'ducl13/spree_sitemap', branch: 'master'
gem 'spree_paypal_express', github: 'ducl13/better_spree_paypal_express'
gem 'spree_product_feed', github: 'ducl13/spree_product_feed', branch: '3-7-caching'
gem 'spree_yotpo', git: 'https://gitlab.com/duc.lam/spree_yotpo.git', branch: 'naturesflavors'
gem 'spree_related_products', github: 'ducl13/spree_related_products'

group :production do
  gem 'spree_mailchimp_ecommerce', github: 'ducl13/spree_mailchimp_ecommerce', branch: 'master'
end

# Use Redis & Sidekiq
gem 'redis', github: 'ducl13/redis-rb'
gem 'sidekiq', github: 'ducl13/sidekiq', branch: 'naturesflavors'
gem "sidekiq-cron", github: 'ducl13/sidekiq-cron'
gem "libxml-ruby", github: 'ducl13/libxml-ruby'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #gem "letter_opener", group: :development
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'browser', github: 'ducl13/browser', branch: 'master'

# For data migration
gem 'erubis', '~> 2.7'
gem 'datashift', github: 'ducl13/datashift', branch: 'naturesflavors'
gem 'datashift_spree', github: 'ducl13/datashift_spree', branch: 'naturesflavors'
gem 'spree_slider', github: 'ducl13/spree_slider', branch: 'master'
