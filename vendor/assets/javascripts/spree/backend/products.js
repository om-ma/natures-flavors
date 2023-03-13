/* global show_flash */
$(function () {
  $('[data-hook=products_clear_cache] #admin_product_clear_cache').click(function () {
    if (confirm(Spree.translations.are_you_sure)) {
      $.ajax({
        type: 'POST',
        url: 'clear_product_cache',
        data: {
          authenticity_token: AUTH_TOKEN
        },
        dataType: 'json'
      }).done(function () {
        show_flash('success', 'Clear product cache queued.')
      })
        .fail(function (message) {
          if (message.responseJSON['error']) {
            show_flash('error', message.responseJSON['error'])
          } else {
            show_flash('error', 'There was a problem while queueing to clear product cache.')
          }
        })
    }
  })
})
