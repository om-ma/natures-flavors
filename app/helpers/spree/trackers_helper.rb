module Spree
  module TrackersHelper
    WORDS_CONNECTOR = ', '.freeze

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

        if product.variants_and_option_values(current_currency).any?
          item_variant = variant.option_values.map{ |o| o.name }.to_sentence(words_connector: WORDS_CONNECTOR, two_words_connector: WORDS_CONNECTOR)
          item_name = product.name + ' ' + item_variant
        else
          item_variant = ''
          item_name = product.name
        end

        {
          item_id: variant.sku,
          item_name: item_name,
          index: index,
          item_brand: product.brand&.name,
          item_category: product.category&.name,
          item_variant: item_variant,
          price: variant.price_in(current_currency).amount&.to_f,
          quantity: line_item.quantity
        }.compact_blank.to_json.html_safe
      end
    end
  end
end
