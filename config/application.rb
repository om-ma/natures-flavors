require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NaturesFlavors
  class Application < Rails::Application

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.assets.initialize_on_precompile = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = "Pacific Time (US & Canada)"
    
    # SMTP header and bcc for https://www.engage.so
    config.action_mailer.default_options = { bcc: "mails@ses.engage.so", "X-SES-CONFIGURATION-SET" => "engage_so", "ConfigurationSetName" => "engage_so" }
    
    # Custom error pages
    config.exceptions_app = self.routes

    # For schema.org structure data
    config.organization = "Nature's Flavors"
    config.brand = "Nature's Flavors"
    config.price_valid_until = "2100-01-01"
  end
end
