Spree::FrontendHelper.class_eval do
  def checkout_edit_link(step = 'address', order = @order)
    return if order.uneditable?

    classes = ''

    link_to spree.checkout_state_path(step), class: classes, method: :get do
      "Edit"
    end
  end
  def taxons_tree(root_taxon, current_taxon, max_level = 3)
    return '' if max_level < 1
    selected_parent_taxon_name = params["id"]
    show_klass =  (root_taxon.children.where(hide_from_nav: false).pluck("permalink").include?(selected_parent_taxon_name) && root_taxon.parent.present?) ? 'show' : ''
    parent_klass = (root_taxon.children.where(hide_from_nav: false).present? && ((root_taxon&.parent&.name == "PRODUCTS") || (root_taxon == current_taxon ))) ? 'sidebar-sub-categories' : "dropdown-menu sub-child-manu-js #{show_klass}"
    
    content_tag :ul, class: parent_klass   do

      taxons = root_taxon.children.where(hide_from_nav: false).map do |taxon|
        # if taxon.products.present?
          taxon_permalink = taxon.permalink
          selected_taxon_klass = selected_parent_taxon_name == taxon_permalink ? 'active-tab' : ''
          content_tag :li do
            css_class = taxon.children.present?  ? 'dropdown-toggle tab-width border-0 p-0' : 'border-0 p-0'
            link_to(taxon.name, seo_url(taxon),class: selected_taxon_klass) + (taxon.children.any? ? '<button type="button" class="dropdown-toggle js_drop_down" data-toggle="dropdown">Toggle me</button>'.html_safe : '') + taxons_tree(taxon, current_taxon, max_level - 1)
          end
        # end
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
      # if product
      #  crumbs << content_tag(:li, content_tag(
      #    :span, content_tag(
      #    :span, product.name, itemprop: 'name'
      #  ) << content_tag(:meta, nil, itemprop: 'position', content: ancestors.size + 2), itemprop: 'url', href: spree.product_path(product, taxon_id: taxon&.id)
      #  ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: spree.product_path(product, taxon_id: taxon&.id)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item ')
      # end
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

  def carousel_image_source_set(image)
    return '' unless image

    widths = { lg: 1200, md: 992, sm: 768, xs: 576 }
    set = []
    widths.each do |key, value|
      file = image.my_cf_image_url("plp_and_carousel_#{key}")

      set << "#{file} #{value}w"
    end
    set.join(', ')
  end

  def sale_date_time_counter(date)
    date.strftime('%b %d, %Y %H:%M:%S')
  end

  def shop_now_url()
    products_category	= Spree::Taxon.find_by_name("PRODUCTS")
		if products_category.present? && products_category&.children.present?
      seo_url(products_category&.children.sample)
    else
      "/"
    end
  end

  def taxon_short_description(taxon)
    if taxon.short_description.present?
      strip_tags(taxon.short_description)
    else
      if @taxon.description.present?
        sentences = strip_tags(@taxon.description).split('.')
        short_description = ''
        sentences.each do |sentence|
          if (short_description + ". " + sentence).length > 260
            return short_description
          else
            short_description = short_description + sentence + ". "
          end
        end
      else
        ""
      end
    end
  end

  def taxon_description(taxon)
    if taxon.short_description.present?
      taxon.description.html_safe
    else
      if @taxon.description.present?
        sentences = strip_tags(@taxon.description).split('.')
        short_description = ''
        start_index = 0
        sentences.each_with_index do |sentence, i|
          if (short_description + ". " + sentence).length > 260
            return sentences.drop(i).join(". ")
          else
            short_description = short_description + sentence + ". "
          end
        end
      else
        ""
      end
    end
  end
end

def google_product_type(product)
  ignore_list = []
  
  if product.taxons.length == 0
    return ''
  elsif product.taxons.length > 1
    product_taxons = product.taxons.select{ |x| !ignore_list.include?(x.name.downcase) }
  else
    product_taxons = product.taxons
  end
  
  product_types = product_taxons.map { |taxon|
    crumbs = ""
    crumbs = taxon.ancestors.drop(1).collect.with_index{ |ancestor, index| ancestor.name + ' > ' } unless taxon.ancestors.empty?
    crumbs << taxon.name

    if crumbs.kind_of?(Array)
      crumb_list = crumbs.flatten.map(&:mb_chars).join
    else
      crumb_list = crumbs
    end
  }

  first_deepest_taxon = product_types.max_by { |x| x.count('>') }
  max_deep = first_deepest_taxon.nil? ? 0 : first_deepest_taxon.count('>')
  result = product_types.select { |x| x.count('>') == max_deep }
  
  if result.kind_of?(Array)
    result.join(', ')
  else
    result
  end
end

def doofinder_categories(product)
  ignore_list = []

  if product.taxons.length == 0
    return ''
  elsif product.taxons.length > 1
    product_taxons = product.taxons.select{ |x| !ignore_list.include?(x.name.downcase) }
  else
    product_taxons = product.taxons
  end
  
  product_types = product_taxons.map { |taxon|
    crumbs = ""
    crumbs = taxon.ancestors.collect.with_index{ |ancestor, index| ancestor.name + ' > ' } unless taxon.ancestors.empty?
    crumbs << taxon.name

    if crumbs.kind_of?(Array)
      crumb_list = crumbs.flatten.map(&:mb_chars).join
    else
      crumb_list = crumbs
    end
  }

  if product_types.kind_of?(Array)
    product_types.join(', ')
  else
    product_types
  end
end