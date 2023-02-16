module Spree
  module TrackersHelper
    def ga_line_item(line_item, index)
      variant = line_item.variant

      cache_key = [
        'spree-ga-line-item',
        I18n.locale,
        current_currency,
        line_item.cache_key_with_version,
        variant.cache_key_with_version
      ].compact.join('/')

      Rails.cache.fetch(cache_key) do
        product = line_item.product
        {
          item_id: variant.sku,
          item_name: variant.name,
          index: index,
          item_brand: product.brand&.name,
          item_category: product.category&.name,
          item_variant: variant.options_text,
          price: variant.price_in(current_currency).amount&.to_f,
          quantity: line_item.quantity
        }.to_json.html_safe
      end
    end
  end
end
