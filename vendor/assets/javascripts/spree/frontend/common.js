$(document).ready(function(){
    var showChar = 260;
    var ellipsestext = "...";
    var moretext = "Read More";
    var lesstext = "less";
    $('.more').each(function() {
        var content = $(this).html();
        if(content.length > showChar) {
        var c = content.substr(0, showChar);
        var h = content.substr(showChar-1, content.length - showChar);
        var html = c + '<span class="moreellipses">' + ellipsestext+ '&nbsp;</span><span class="morecontent"><span>' + h + '</span>&nbsp;<a href="" class="morelink">' + moretext + '</a></span>';
        $(this).html(html);
        }
    });
    
    $(".morelink").click(function(){
        if($(this).hasClass("less")) {
        $(this).removeClass("less");
        $(this).html(moretext);
        } else {
        $(this).addClass("less");
        $(this).html(lesstext);
        }
        $(this).parent().prev().toggle();
        $(this).prev().toggle();
        return false;
    });
    })

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