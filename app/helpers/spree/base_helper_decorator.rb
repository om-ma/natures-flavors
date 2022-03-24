Spree::BaseHelper.module_eval do

    def seo_url(taxon, params = nil)
      categories_path(taxon.permalink, params)
    end

end
