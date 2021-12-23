Spree::FrontendHelper.class_eval do

  def taxons_tree(root_taxon, current_taxon, max_level = 3)
    return '' if max_level < 1
    selected_parent_taxon_name = params["id"]
    show_klass =  (root_taxon.children.pluck("permalink").include?(selected_parent_taxon_name) && root_taxon.parent.present?) ? 'show' : ''
    parent_klass = (root_taxon.children.present? && ((root_taxon&.parent&.name == "Categories") || (root_taxon == current_taxon ))) ? 'sidebar-sub-categories' : "dropdown-menu sub-child-manu-js #{show_klass}"
    content_tag :ul, class: parent_klass   do

      taxons = root_taxon.children.map do |taxon|
        if taxon.products.present?
          taxon_permalink = taxon.permalink
          selected_taxon_klass = selected_parent_taxon_name == taxon_permalink ? 'active-tab' : ''
          content_tag :li do
            css_class = taxon.children.present?  ? 'dropdown-toggle tab-width' : ''
            link_to(taxon.name,seo_url(taxon), class: "#{selected_taxon_klass} #{css_class}", data: {toggle: 'dropdown'})+ taxons_tree(taxon, current_taxon, max_level - 1)
          end
        end
      end
      safe_join(taxons, "\n")
    end
  end

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
      if product.present?
        crumbs << content_tag(:li, content_tag(
          :a,content_tag(
          :span, taxon.name, itemprop: 'name'
        ) << content_tag(:meta, nil, itemprop: 'position', content: ancestors.size + 1), itemprop: 'url', href: seo_url(taxon, params: permitted_product_params)
        ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: seo_url(taxon, params: permitted_product_params)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item active' )
      else
        crumbs << content_tag(:li, content_tag(
          :div,content_tag(
          :span, taxon.name, itemprop: 'name'
        ) << content_tag(:meta, nil, itemprop: 'position', content: ancestors.size + 1), itemprop: 'url', href: seo_url(taxon, params: permitted_product_params)
        ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: seo_url(taxon, params: permitted_product_params)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item active' )
      end
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

  def plp_and_carousel_image(product, image_class = '')
    image = default_image_for_product_or_variant(product)

    image_url = if image.present?
                  main_app.url_for(image.url('plp'))
                else
                  asset_path('noimage/default-product-image.jpg')
                end

    image_style = image&.style(:plp)

    lazy_image(
      src: image_url,
      srcset: carousel_image_source_set(image),
      alt: product.name,
      width: image_style&.dig(:width) || 278,
      height: image_style&.dig(:height) || 371,
      class: "product-component-image d-block mw-100 #{image_class}"
    )
  end
end