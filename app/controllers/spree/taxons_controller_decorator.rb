Spree::TaxonsController.class_eval do
    def show

      if stale? [@taxon, @products, @taxonomies, simple_current_order]
        if params.include?('per_page')
          @per_page = params['per_page'].to_i
        else
          @per_page = 24
          params['per_page'] = @per_page
        end if

        @taxon = Spree::Taxon.friendly.find(params[:id])
        return unless @taxon
        @searcher = build_searcher(params.merge(taxon: @taxon, include_images: true))
          list = ['descend_by_popularity', 'ascend_by_name', 'descend_by_name']
          if list.include?(params[:sorting])
              sorting_scope = params[:sorting].try(:to_sym) || :ascend_by_name
          else
              sorting_scope = :ascend_by_name
          end
        if params[:sorting] == "bestsellers"

          @products = @searcher.retrieve_products.send(sorting_scope).best_sellers.page(params[:page]).per(params[:per_page])
        else  
          @products = @searcher.retrieve_products.send(sorting_scope).page(params[:page]).per(params[:per_page])
        end
        @taxonomies = Spree::Taxonomy.includes(root: :children).where('name ILIKE ?','%PRODUCTS%')
      end
    end
end
