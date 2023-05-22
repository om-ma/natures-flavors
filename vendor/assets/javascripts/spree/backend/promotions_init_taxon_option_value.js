function initTaxonOptionValueAction () {
  'use strict'

  //
  // Taxon Option Value Promo Rule
  //
  if ($('#promo-rule-taxon-option-value-template').length) {
    var optionValueSelectNameTemplate = Handlebars.compile($('#promo-rule-taxon-option-value-option-values-select-name-template').html())
    var optionValueTemplate = Handlebars.compile($('#promo-rule-taxon-option-value-template').html())
    var optionValuesList = $('.js-promo-rule-taxon-option-values')

    var addOptionValue = function (optionTypeId, values) {
      var template = optionValueTemplate({
        optionTypeId: optionTypeId
      })

      optionValuesList.append(template)

      var optionValueId = '#promo-rule-taxon-option-value-'
      if (optionTypeId) {
        optionValueId += optionTypeId.toString()
      }
      var optionValue = optionValuesList.find(optionValueId)

      var optionTypeSelect = optionValue.find('.js-promo-rule-taxon-option-value-option-type-select')
      var valuesSelect = optionValue.find('.js-promo-rule-taxon-option-value-option-type-option-values-select')

      optionTypeSelect.taxonOptionValueOptipnTypeAutocomplete({ multiple: false, values: optionTypeId })
      optionTypeSelect.on('select2:select', function(e) {
        valuesSelect.attr('disabled', false).removeClass('d-none').addClass('d-block')
        valuesSelect.attr('name', optionValueSelectNameTemplate({ optionTypeId: optionTypeSelect.val() }).trim())
        valuesSelect.taxonOptionValueOptionValueAutocomplete({
          optionTypeId: optionTypeId,
          optionTypeSelect: optionTypeSelect,
          multiple: true,
          values: values,
          clearSelection: optionTypeId != optionTypeSelect.val()
        })
      })
    }

    var originalOptionValues = $('.js-original-promo-rule-taxon-option-values').data('original-option-values')
    if (!$('.js-original-promo-rule-taxon-option-values').data('loaded')) {
      if ($.isEmptyObject(originalOptionValues)) {
        addOptionValue(null, null)
      } else {
        $.each(originalOptionValues, addOptionValue)
      }
    }
    $('.js-original-promo-rule-taxon-option-values').data('loaded', true)

    $(document).on('click', '.js-add-promo-rule-taxon-option-value', function (event) {
      event.preventDefault()
      addOptionValue(null, null)
    })

    $(document).on('click', '.js-remove-promo-rule-taxon-option-value', function () {
      // DTL: Can't find this class
      // $(this).parents('.promo-rule-option-value').remove()
      $(this).parents('.promo-rule-taxon-option-value').remove()
    })
  }
}

$(document).ready(function () {
  var promotion_form = $('form.edit_promotion')

  if (promotion_form.length) {
    initTaxonOptionValueAction()
  }
})
