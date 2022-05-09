$( document ).on('turbolinks:load', function() {
    $(".payment-change-billing-address").on('click',function(){
      $("#payment-billing-address").removeClass("d-none");
    })
    $(".payment-change-shipping-address").on('click',function(){
      $("#payment-billing-address").addClass("d-none");
    })
 });
