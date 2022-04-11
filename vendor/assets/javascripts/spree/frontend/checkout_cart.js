$(document).on('turbolinks:load', function() {
  $("#shopping-cart-coupon-code-button").on("click", function(event) {

     var input = {
       couponCodeField: $('#order_coupon_code'),
       couponStatus: $('#coupon_status'),
       couponButton: $('#shopping-cart-coupon-code-button')
     }

     if ($.trim(input.couponCodeField.val()).length > 0) {
     // eslint-disable-next-line no-undef
       if (new CouponManager(input).applyCoupon()) {
         window.location = window.location
         return true
       } else {
         alert("error")
         return false
       }
     }

   });
  $("button#shopping-cart-remove-coupon-code-button").on("click", function(event) {
     var input = {
       appliedCouponCodeField: $('#order_applied_coupon_code'),
       couponCodeField: $('#order_coupon_code'),
       couponStatus: $('#coupon_status'),
       couponButton: $('#shopping-cart-coupon-code-button'),
       removeCouponButton: $('#shopping-cart-remove-coupon-code-button')
     }

     if (new CouponManager(input).removeCoupon()) {
       window.location = window.location
       return true
     } 
   });
});
