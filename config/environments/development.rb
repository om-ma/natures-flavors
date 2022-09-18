Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    #config.cache_store = :memory_store
    #config.cache_store = :redis_store, "#{ENV['CACHE_URL']}/#{ENV['CACHE_DB_NUM']}"
    config.cache_store = :redis_cache_store, { url: "#{ENV['CACHE_URL']}/#{ENV['CACHE_DB_NUM']}" }

    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=0"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Use a real queuing backend for Active Job (and separate queues per environment)
  config.active_job.queue_adapter     = :sidekiq

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Multi-database middleware for automatic role switching
  config.active_record.database_selector = { delay: 2.seconds }
  config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
  config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #    :address              => "smtp.gmail.com",
  #    :port                 =>  587,
  #    :user_name            => 'omqa2794@gmail.com',
  #    :password             => 'PakistaN@123',
  #    :authentication       => "plain",
  #    :enable_starttls_auto => true
  #
  #  }

  config.assets.raise_runtime_errors = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: "naturesflavors.localhos:3000" }
  config.action_mailer.asset_host = "http://naturesflavors.localhost:3000"
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "email-smtp.us-east-1.amazonaws.com",
    :port                 =>  587,
    :domain               => "us-east-1.amazonaws.com",
    :user_name            => ENV['ACTION_MAILER_USER_NAME'],
    :password             => ENV['ACTION_MAILER_PASSWORD'],
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
  
  config.action_mailer.default_options = { from: ENV['ACTION_MAILER_FROM'] }
  config.action_mailer.deliver_later_queue_name = "mailers"

  # Email address for sending back office invoice and packaging list for an order to be printed automatically
  config.x.backoffice.print_docs = true
  config.x.backoffice.to_address = 'it-group@naturesflavors.com'

  # Google Tag Manager
  config.x.trackers.google_tag_manager = 'GTM-KGMXPGQ'
  
  # YotPo - Staging keys
  config.x.yotpo.app_key = 'j7hsvZFhxG8jUooYglRviEapbHJAmxE7hCrOhHmH'
  config.x.yotpo.secret_key = 'g6mJW31KvNIVFBNRU8pYrVGaY9kwPyAPZ76WZ6Zs'
  config.x.yotpo.rich_snippets_refresh_time = 25.hours
  config.x.yotpo.reviews_refresh_time = 25.hours

  # Low-level cache expiration
  config.x.cache.expiration = 24.hours

  # Sidekiq data workers cache expiration
  config.x.products.refresh_time = 25.hours

  # Doofinder
  config.x.doofinder.search_zone = 'us1'
  config.x.doofinder.api_key = 'us1-aa01ed99b4e66cf41f0ce41ae96c7abf246264f5'
  config.x.doofinder.hashid = 'e5a0cc4ebeb29bd09d2801b99933812f'
end

# spree_sitemap config
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
                                                                    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
                                                                    fog_provider:          'AWS',
                                                                    fog_directory:         ENV['S3_SITEMAPS_BUCKET'])
SitemapGenerator::Sitemap.sitemaps_host = "http://naturesflavors-development-sitemaps.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.default_host = "http://naturesflavors.localhost:3000"

Rails.application.default_url_options = { host: "http://naturesflavors.localhost:3000" }