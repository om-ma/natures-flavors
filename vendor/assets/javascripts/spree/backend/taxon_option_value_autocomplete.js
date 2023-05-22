$.fn.taxonOptionValueAutocomplete = function() {
  'use strict'

  function formatTaxonList(values) {
    console.warn('taxonOptionValueAutocomplete is deprecated and will be removed in Spree 5.0')

    return values.map(function (obj) {
      return {
        id: obj.id,
        text: obj.pretty_name
      }
    })
  }

  this.select2({
    multiple: true,
    placeholder: Spree.translations.taxon_placeholder,
    minimumInputLength: 2,
    ajax: {
      url: Spree.routes.taxons_api,
      dataType: 'json',
      data: function (params) {
        return {
          q: {
            name_cont: params.term
          },
          token: Spree.api_key
        }
      },
      processResults: function(data) {
        return {
          results: formatTaxonList(data.taxons)
        }
      }
    }
  })
}

$(document).ready(function () {
  var productTaxonSelector = document.getElementById('taxon_option_value_product_taxon_ids')
  if (productTaxonSelector == null) return
  if (productTaxonSelector.hasAttribute('data-autocomplete-url-value')) return

  $('#taxon_option_value_product_taxon_ids').taxonOptionValueAutocomplete()
})
