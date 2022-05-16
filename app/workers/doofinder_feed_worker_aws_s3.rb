class DoofinderFeedWorkerAwsS3
  include Sidekiq::Worker

  def perform()
    DoofinderFeedCreator.call(Rails.application.default_url_options, true, true)
  end
end