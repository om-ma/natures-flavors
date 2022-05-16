class DoofinderFeedWorker
  include Sidekiq::Worker

  def perform()
    DoofinderFeedCreator.call(Rails.application.default_url_options, true)
  end
end