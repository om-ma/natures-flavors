class SitemapRefreshWorker
  include Sidekiq::Worker

  def perform()
    Rails.application.load_tasks
    Rake::Task['sitemap:refresh'].invoke
  end
  
end