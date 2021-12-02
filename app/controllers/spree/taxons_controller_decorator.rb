Spree::TaxonsController.class_eval do
  def show
    if stale? [@taxon, @products, @taxonomies, simple_current_order]
      if params.include?('per_page')
        @per_page = params['per_page'].to_i
      else
        @per_page = 20
        params['per_page'] = @per_page
      end

      @taxon = Spree::Taxon.friendly.find(params[:id])
      
      return unless @taxon

      search_params = params.merge(
        current_store: current_store,
        taxon: @taxon,
        include_images: true
      )
      @searcher = build_searcher(search_params)
      list      = ['descend_by_popularity', 'ascend_by_name', 'descend_by_name']

      if list.include?(params[:sorting])
        sorting_scope = params[:sorting].try(:to_sym) || :ascend_by_name
      else
        sorting_scope = :ascend_by_name
      end 
      @products = @searcher.retrieve_products.send(sorting_scope).page(params[:page]).per(params['per_page'])
      @taxonomies = Spree::Taxonomy.includes(root: :children).where('name ILIKE ?','%PRODUCTS%')
    end
  end
end
