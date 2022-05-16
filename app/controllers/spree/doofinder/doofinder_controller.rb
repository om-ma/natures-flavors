class Spree::Doofinder::DoofinderController < Spree::StoreController
    
    def feed
        DoofinderFeedCreator.call(Rails.application.default_url_options, true)
        @feed_from_cache = Rails.cache.read(DoofinderFeedCreator::CACHED_KEY)
        
        render layout: false
    end

end
