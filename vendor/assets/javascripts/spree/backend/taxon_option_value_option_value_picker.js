$.fn.taxonOptionValueOptionValueAutocomplete = function (options) {
  'use strict'

  // Default options
  options = options || {}
  var multiple = typeof (options.multiple) !== 'undefined' ? options.multiple : true
  var optionTypeSelect = options.optionTypeSelect
  var optionTypeId = options.optionTypeId
  var values = options.values
  var clearSelection = options.clearSelection

  function addOptions(select, optionTypeId, values) {
    $.ajax({
      type: 'GET',
      url: Spree.routes.option_values_api_v2,
      headers: Spree.apiV2Authentication(),
      dataType: 'json',
      data: {
        filter: {
          id_in: values,
          option_type_id_eq: optionTypeId
        }
      }
    }).then(function (data) {
      select.addSelect2Options(data.data)
    })
  }

  this.select2({
    multiple: multiple,
    minimumInputLength: 1,
    ajax: {
      url: Spree.routes.option_values_api_v2,
      dataType: 'json',
      headers: Spree.apiV2Authentication(),
      data: function (params) {
        var selectedOptionTypeId = typeof (optionTypeSelect) !== 'undefined' ? optionTypeSelect.val() : null

        return {
          filter: {
            name_cont: params.term,
            option_type_id_eq: selectedOptionTypeId
          }
        }
      },
      processResults: function(data) {
        return formatSelect2Options(data)
      }
    }
  })

  if (values && optionTypeId && !clearSelection) {
    addOptions(this, optionTypeId, values)
  }

  if (clearSelection) {
    this.val(null).trigger('change')
  }
}
