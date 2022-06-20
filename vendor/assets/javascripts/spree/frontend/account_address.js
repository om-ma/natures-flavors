$( document ).on('turbolinks:load', function() {
  $(document).on('click', '#account-address-tab', function(){

    $.ajax({
      type: 'GET',
      url: '/addresses/new.js',
    }).done(function () {
    }).fail(function (response) {
    })
  });
  $(document).on('click', '.js-edit-address-from-profile', function(){
    let address_id = $(this).data('address-id')
    $.ajax({
      type: 'GET',
      url: '/addresses/'+ address_id +'/edit.js',
    }).done(function () {
    }).fail(function (response) {
    })

  });

  $(document).on('click', '.js-set-address-as-default', function(){
    let address_id = $(this).data('address-id')
    $.ajax({
      type: 'GET',
      url: '/set_address_as_default.js',
      data: {id: address_id}
    }).done(function () {
    }).fail(function (response) {
    })

  });


  $(document).on('click', '.js-set-cc-as-default', function(){
    let currentCC = $(this).data('cc-id')
    $.ajax({
      type: 'GET',
      url: '/set_cc_as_default.js',
      data: {id: currentCC}
    }).done(function () {
    }).fail(function (response) {
    })
  });

});