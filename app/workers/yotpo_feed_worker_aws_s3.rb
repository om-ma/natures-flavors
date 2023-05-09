class YotpoFeedWorkerAwsS3
  include Sidekiq::Worker

  def perform()
    YotpoFeedCreator.call(Rails.application.default_url_options, true)
  end
end