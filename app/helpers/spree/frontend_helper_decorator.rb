Spree::FrontendHelper.class_eval do 

    def spree_breadcrumbs(taxon, _separator = '', product = nil)
        return ''  if current_page?('/') || taxon.nil?

        # breadcrumbs for root
        crumbs = [content_tag(:li, content_tag(
          :a, content_tag(
            :span, Spree.t(:home), itemprop: 'name'
          ) << content_tag(:meta, nil, itemprop: 'position', content: '0'), itemprop: 'url', href: spree.root_path
        ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: spree.root_path), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item')]
  
        if taxon
          ancestors = taxon.ancestors.where.not(parent_id: nil)
  
          # breadcrumbs for ancestor taxons
          crumbs << ancestors.each_with_index.map do |ancestor, index|
            content_tag(:li, content_tag(
              :a, content_tag(
                :span, ancestor.name, itemprop: 'name'
              ) << content_tag(:meta, nil, itemprop: 'position', content: index + 1), itemprop: 'url', href: seo_url(ancestor, params: permitted_product_params)
            ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: seo_url(ancestor, params: permitted_product_params)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item')
          end
  
          # breadcrumbs for current taxon
          crumbs << content_tag(:li, content_tag(
              :div,content_tag(
              :span, taxon.name, itemprop: 'name'
            ) << content_tag(:meta, nil, itemprop: 'position', content: ancestors.size + 1), itemprop: 'url', href: seo_url(taxon, params: permitted_product_params)
          ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: seo_url(taxon, params: permitted_product_params)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item active' )
  
          # breadcrumbs for product
          if product
            crumbs << content_tag(:li, content_tag(
              :span, content_tag(
                :span, product.name, itemprop: 'name'
              ) << content_tag(:meta, nil, itemprop: 'position', content: ancestors.size + 2), itemprop: 'url', href: spree.product_path(product, taxon_id: taxon&.id)
            ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: spree.product_path(product, taxon_id: taxon&.id)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item ')
          end
        else
          # breadcrumbs for product on PDP
          crumbs << content_tag(:li, content_tag(
            :span, Spree.t(:products), itemprop: 'item'
          ) << content_tag(:meta, nil, itemprop: 'position', content: '1'), class: 'active', itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement')
        end
       content_tag(:ol, raw(crumbs.flatten.map(&:mb_chars).join), class: 'breadcrumb', itemscope: 'itemscope', itemtype: 'https://schema.org/BreadcrumbList')
      end
         

end