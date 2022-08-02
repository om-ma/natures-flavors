module Spree
  module Admin
    GeneralSettingsController.class_eval do

      # Override to call sidekiq worker(s)
      def clear_cache
        Rails.cache.clear
        invoke_callbacks(:clear_cache, :after)
        head :no_content

        # YotPo cache worker
        YotpoCacheWorker.perform_async()
      end
      
    end
  end
end
