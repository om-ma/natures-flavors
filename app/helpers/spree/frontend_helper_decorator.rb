Spree::FrontendHelper.class_eval do
  
  def pagy_url_for(pagy, page, absolute: false, html_escaped: false)  # it was (page, pagy) in previous versions
    params = request.query_parameters.merge(pagy.vars[:page_param] => page, only_path: !absolute )
    html_escaped ? url_for(params).gsub('&', '&amp;') : url_for(params)
  end

  # Pagination for bootstrap: it returns the html with the series of links to the pages
  def pagy_bootstrap_nav(pagy, pagy_id: nil, link_extra: '', **vars)
    return '' if pagy.pages == 1

    link = pagy_link_proc(pagy, link_extra: %(#{link_extra}))

    html = +%(<ul class="pagination d-flex align-items-center justify-content-center">)
    html << pagy_bootstrap_prev_html(pagy, link)
    
    pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
              when Integer
                %(<li class="page-item">#{link.call item, item, 'data-turbolinks="false" class="page-link"'}</li>)
              when String
                %(<li class="page-item">#{link.call item, item, 'data-turbolinks="false" class="page-link active"'}</li>)
              when :gap
                %(<li class="page-item page gap disabled d-none d-lg-flex"><a href="#" onclick="return false;" data-turbolinks="false" class="page-link">#{pagy_t('pagy.nav.gap')}</a></li>)
              else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
              end
    end
    html << pagy_bootstrap_next_html(pagy, link)
    html << %(</ul>)
    
    html << %(<div class="pagination-counter d-flex align-items-center">)
    html << %(Showing #{pagy.page == 1 ? pagy.page : pagy.page * Pagy::DEFAULT[:items] - (pagy.in)} - #{pagy.page * Pagy::DEFAULT[:items]} of #{pagy.count} products)
    html << %(</div>)

  end

  def pagy_bootstrap_prev_html(pagy, link)
    if (p_prev = pagy.prev)
      prev_page_klass = pagy.page == pagy.pages ? 'btn btn-primary prev-page-icon' : 'btn btn-outline mobile-hide'
      %(<li class="page-item">#{link.call pagy.prev, '<span>Previous Page</span>', "data-turbolinks=\"false\" class=\"#{prev_page_klass}\" aria-label=\"previous\""}</li>)
    else
      ''
    end
  end

  def pagy_bootstrap_next_html(pagy, link)
    if (p_next = pagy.next)
      %(<li class="page-item next">#{link.call pagy.next, '<span>Next Page</span>', 'data-turbolinks="false" class="btn btn-primary" aria-label="next" rel="next"'}</li>)
    else
      ''
    end
  end
  
  # <link rel="next" href="/items/page/3"><link rel="prev" href="/items/page/1">
  def pagy_rel_next_prev_link_tags(pagy)
    next_page = pagy_next_page_path(pagy)
    prev_page = pay_prev_page_path(pagy)

    output = String.new
    output << %Q|<link rel="next" href="#{next_page}">| if next_page
    output << %Q|<link rel="prev" href="#{prev_page}">| if prev_page
    output.html_safe
  end

  def pagy_next_page_path(pagy)
    if pagy.next
      pagy_url_for(pagy, pagy.next)
    else
      nil
    end
  end

  def pay_prev_page_path(pagy)
    if pagy.prev
      pagy_url_for(pagy, pagy.prev)
    else
      nil
    end
  end

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
            link_to(taxon.name, seo_url(taxon), data: { turbolinks: false }, class: selected_taxon_klass) + (taxon.children.any? ? '<button type="button" class="dropdown-toggle js_drop_down" data-toggle="dropdown">Toggle me</button>'.html_safe : '') + taxons_tree(taxon, current_taxon, max_level - 1)
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
    ) << content_tag(:meta, nil, itemprop: 'position', content: '0'), itemprop: 'url', href: spree.root_path, data: { turbolinks: false }
    ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: spree.root_path), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item')]

    if taxon
      ancestors = taxon.ancestors.where.not(parent_id: nil)

      # breadcrumbs for ancestor taxons
      crumbs << ancestors.each_with_index.map do |ancestor, index|
        content_tag(:li, content_tag(
          :a, content_tag(
          :span, ancestor.name, itemprop: 'name'
        ) << content_tag(:meta, nil, itemprop: 'position', content: index + 1), itemprop: 'url', href: seo_url(ancestor, params: permitted_product_params), data: { turbolinks: false }
        ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: seo_url(ancestor, params: permitted_product_params)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item')
      end

      # breadcrumbs for current taxon
      if product.present?
        crumbs << content_tag(:li, content_tag(
          :a,content_tag(
          :span, taxon.name, itemprop: 'name'
        ) << content_tag(:meta, nil, itemprop: 'position', content: ancestors.size + 1), itemprop: 'url', href: seo_url(taxon, params: permitted_product_params), data: { turbolinks: false }
        ) << content_tag(:span, nil, itemprop: 'item', itemscope: 'itemscope', itemtype: 'https://schema.org/Thing', itemid: seo_url(taxon, params: permitted_product_params)), itemscope: 'itemscope', itemtype: 'https://schema.org/ListItem', itemprop: 'itemListElement', class: 'breadcrumb-item active' )
      else
        crumbs << content_tag(:li, content_tag(
          :div,content_tag(
          :span, taxon.name, itemprop: 'name'
        ) << content_tag(:meta, nil, itemprop: 'position', content: ancestors.size + 1), itemprop: 'url', href: seo_url(taxon, params: permitted_product_params), data: { turbolinks: false }
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
                  image.my_cf_image_url('plp')
                else
                  asset_path('noimage/default-product-image.jpg')
                end

    image_style = image&.style(:plp)

    lazy_image(
      src: image_url,
      srcset: carousel_image_source_set(image),
      alt: (image&.alt.present? ? image.alt : product.name),
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
  
  def cache_key_for_all_categories(all_categories = @all_categories, additional_cache_key = nil)
    max_updated_at = (all_categories.except(:group, :order).maximum(:updated_at) || Date.today).to_s(:number)
    "spree/all_categories/#{all_categories.map(&:id).join('-')}"
  end

  def cache_key_for_products_no_updated_at(products = @products, taxon = @taxon, additional_cache_key = nil)
    if products.present?
      products_cache_keys = "spree/products/#{products.map(&:id).join('-')}-#{params[:page]}-#{params[:sort_by]}-#{taxon&.id}"
    else
      products_cache_keys = "spree/products/nil-#{params[:page]}-#{params[:sort_by]}-#{taxon&.id}"
    end
    (common_product_cache_keys + [products_cache_keys] + [additional_cache_key]).compact.join('/')
  end

  def cache_key_for_home_index(all_categories = @all_categories, home_slides = @home_slides, best_sellers_products = @best_sellers_products, deals_products = @deals_products, popular_extracts_products = @popular_extracts_products, popular_powders_products = @popular_powders_products, popular_oils_products = @popular_oils_products)
    all_categories_cache_keys            = cache_key_for_all_categories(all_categories)
    home_slides_cache_keys               = cache_key_for_sliders(home_slides)
    best_sellers_products_cache_keys     = cache_key_for_best_sellers(best_sellers_products)
    deals_products_cache_keys            = cache_key_for_products_no_updated_at(deals_products)
    popular_extracts_products_cache_keys = cache_key_for_products_no_updated_at(popular_extracts_products)
    popular_powders_products_cache_keys  = cache_key_for_products_no_updated_at(popular_powders_products)
    popular_oils_products_cache_keys     = cache_key_for_products_no_updated_at(popular_oils_products)
    ([all_categories_cache_keys] + [home_slides_cache_keys] + [best_sellers_products_cache_keys] + [deals_products_cache_keys] + [popular_extracts_products_cache_keys] + [popular_powders_products_cache_keys] + [popular_oils_products_cache_keys]).compact.join('/')
  end

  def cache_key_for_taxon_show(all_categories = @all_categories, products = @products)
    all_categories_cache_keys = cache_key_for_all_categories(all_categories)
    products_cache_keys       = cache_key_for_products_no_updated_at(products)
    ([all_categories_cache_keys] + [products_cache_keys]).compact.join('/')
  end

  def cache_key_for_taxon_show_top_level_subcategories(products = @products, taxon = @taxon)
    products_cache_keys = cache_key_for_products_no_updated_at(products)
    ([products_cache_keys]).compact.join('/')
  end

  def deep_dup(obj)
    Marshal.load(Marshal.dump(obj))
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