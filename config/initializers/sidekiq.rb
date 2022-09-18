# frozen_string_literal: true

sidekiq_config = { url: "#{ENV['SIDEKIQ_REDIS_URL']}", db: ENV['SIDEKIQ_REDIS_DB_NUM'] }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
  schedule_file = "config/schedule.yml"
  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_server do |config|
  config.failures_max_count = 5000
end