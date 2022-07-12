$( document ).on('turbolinks:load', function() {

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

    $(".js-qunatity-select").change(function() {
    let selectedQty = $(this).val()
    let selectFieldValue = $(this).data("id")
    $(".js-quantity-field").val(selectedQty)
    $(".cart-line-item-" + selectFieldValue).val(parseInt(selectedQty))
    $(".cart-line-item-" + selectFieldValue).trigger('change');
    if(selectedQty > 10 ){
      $(this).hide()
      $(".js-quantity-field").removeClass("d-none");
    }
  });

  $(".js-quantity-field").on("change", function(){
    let selectedQty = $(this).val()
    let fieldValue  = Math.abs(selectedQty - 1)
    if(selectedQty <= 10 ){
      $(this).addClass("d-none");
      $(".js-qunatity-select").show();
      $(".js-qunatity-select").val(selectedQty);
    }
  });
});