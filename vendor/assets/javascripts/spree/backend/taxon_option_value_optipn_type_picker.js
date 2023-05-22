$.fn.taxonOptionValueOptipnTypeAutocomplete = function (options) {
  'use strict'

  // Default options
  options = options || {}
  var multiple = typeof (options.multiple) !== 'undefined' ? options.multiple : true
  var values = typeof (options.values) !== 'undefined' ? options.values : null

  function formatOptionTypeList(option_types) {
    return option_types.map(function(obj) {
      return { id: obj.id, text: obj.attributes.presentation }
    })
  }

  function addOptions(select, values) {
    $.ajax({
      url: Spree.routes.option_types_api_v2,
      headers: Spree.apiV2Authentication(),
      dataType: 'json',
      data: {
        filter: {
          id_in: values
        }
      }
    }).then(function (data) {
      select.addSelect2Options(data.data)
    })
  }

  this.select2({
    multiple: multiple,
    minimumInputLength: 3,
    ajax: {
      url: Spree.routes.option_types_api_v2,
      dataType: 'json',
      headers: Spree.apiV2Authentication(),
      data: function (params) {
        return {
          filter: {
            name_i_cont: params.term
          }
        }
      },
      processResults: function(data) {
        var option_types = data.data ? data.data : []
        var results = formatOptionTypeList(option_types)

        return {
          results: results
        }
      }
    },
    templateSelection: function(data, _container) {
      return data.text
    }
  })

  if (values) {
    addOptions(this, values)
  }
}
