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