/* global show_flash */
$(function () {
  $('[data-hook=create_route_order] #admin_create_route_order').click(function () {
    if (confirm(Spree.translations.are_you_sure)) {
      $.ajax({
        type: 'POST',
        url: 'create_route_order',
        data: {
          authenticity_token: AUTH_TOKEN
        },
        dataType: 'json'
      }).done(function () {
        show_flash('success', 'Create Route order queued.')
      })
        .fail(function (message) {
          if (message.responseJSON['error']) {
            show_flash('error', message.responseJSON['error'])
          } else {
            show_flash('error', 'There was a problem while queueing to create Route order.')
          }
        })
    }
  })
})
