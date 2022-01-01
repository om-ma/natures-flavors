  $(document).ready(function() {

  $(".js-qty-select").change(function() {
    let selectedQty = $(this).val()
    let selectFieldValue = $(this).data("id")
    $(".cart-line-item-" + selectFieldValue).val(parseInt(selectedQty))
    $(".cart-line-item-" + selectFieldValue).trigger('change');

  });

  $(".js-qty-field").on("keyup", function(){
    let selectedQty = $(this).val()
    let fieldValue  = Math.abs(selectedQty - 1)
  });

});
