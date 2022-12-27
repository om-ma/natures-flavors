var billing_address_data = 0
$( document ).on('turbolinks:load', function() {
    $('input#order_use_shipping').on('click',function() {
      if ($('.select_billing_address').length > 0) {
        if ($(this).is(':checked')) {
          $('.select_billing_address').addClass("d-none");
        } else {
          $('.select_billing_address').removeClass("d-none");
        }
      }
    })
});
