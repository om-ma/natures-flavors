var shipping_address_data = 0
$( function() {

    $(".payment-change-billing-address").on('click',function(){
      shipping_address_data = $("#payment-billing-address").html()
      $(".js-address-fields").val("")
      $("#payment-billing-address").removeClass("d-none");
    })
    $(".payment-change-shipping-address").on('click',function(){
      if(shipping_address_data != 0 ) {
        $("#payment-billing-address").html(shipping_address_data)
      }
      $("#payment-billing-address").addClass("d-none");
    })
 });
