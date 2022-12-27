Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = true

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :terser
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :amazon

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store
  config.cache_store = :redis_cache_store, { url: "#{ENV['CACHE_URL']}/#{ENV['CACHE_DB_NUM']}" }
  
  # Use a real queuing backend for Active Job (and separate queues per environment)
  config.active_job.queue_adapter     = :sidekiq
  #config.active_job.queue_name_prefix = "naturesflavors_#{Rails.env}"

  config.action_controller.asset_host = "https://#{ENV['CLOUDFRONT_ASSET_URL']}"
  config.assets.digest = true
  config.assets.enabled = true
  config.assets.prefix = '/assets/v54'
  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Multi-database middleware for automatic role switching
  config.active_record.database_selector = { delay: 2.seconds }
  config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
  config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: "naturesflavors.naturlax.org" }
  config.action_mailer.asset_host = "https://#{ENV['CLOUDFRONT_ASSET_URL']}"
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

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Email address for sending back office invoice and packaging list for an order to be printed automatically
  config.x.backoffice.print_docs = true
  config.x.backoffice.to_address = 'it-group@naturesflavors.com'
  
  # Email address to send system errors
  config.x.systemerror.email = 'it-group@naturesflavors.com'

  # paperclip with S3. for spree_slider images, etc.
  config.paperclip_defaults = {
    :storage => :s3,
    :preserve_files => true,
    :s3_credentials => {
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_KEY'],
      :s3_region => ENV['S3_ASSET_REGION']
    },
    :bucket => ENV['S3_ASSET_BUCKET']
  }
  
  # Google Tag Manager
  config.x.trackers.google_tag_manager = 'GTM-KGMXPGQ'
  
  # YotPo - Staging keys
  config.x.yotpo.app_key = 'j7hsvZFhxG8jUooYglRviEapbHJAmxE7hCrOhHmH'
  config.x.yotpo.secret_key = 'g6mJW31KvNIVFBNRU8pYrVGaY9kwPyAPZ76WZ6Zs'
  config.x.yotpo.rich_snippets_refresh_time = 72.hours
  config.x.yotpo.reviews_refresh_time = 72.hours

  # Low-level cache expiration
  config.x.cache.expiration = 30.days
  config.x.cache.images_backend_clear_on_update = ENV['CACHE_IMAGES_BACKEND_CLEAR_ON_UPDATE']

  # Sidekiq data workers cache expiration
  config.x.products.refresh_time = 72.hours
  
  # Doofinder (production)
  config.x.doofinder.search_zone = 'us1'
  config.x.doofinder.api_key = 'us1-aa01ed99b4e66cf41f0ce41ae96c7abf246264f5'
  config.x.doofinder.hashid = 'e5a0cc4ebeb29bd09d2801b99933812f'

  # Route insurance
  config.x.cache.route_quote_expiration = 24.hours
  config.x.route.integration_enabled = ENV['ROUTE_INTEGRATION_ENABLED']
  config.x.route.merchant_id = 'merch_vvxkoH49riWxHopnelN3'
  config.x.route.public_token = '35539ae7-a7b6-436e-bee5-4d22665cd0a4'
  config.x.route.secret_token = 'test-4cddd2d4-7429-43ec-98b1-255075fa85fd'
end

# spree_sitemap config
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
                                                                    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
                                                                    fog_provider:          'AWS',
                                                                    fog_directory:         ENV['S3_SITEMAPS_BUCKET'])
SitemapGenerator::Sitemap.sitemaps_host = "http://naturesflavors-staging-sitemaps.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.default_host = "https://naturesflavors.naturlax.org"

Rails.application.default_url_options = {host:'https://naturesflavors.naturlax.org'}
Spree::Core::Engine.routes.default_url_options[:host] = 'naturesflavors.naturlax.org'