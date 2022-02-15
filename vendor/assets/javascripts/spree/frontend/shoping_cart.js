  $(document).on("click" , "#shopping_cart_bag", function(e){
    var cartBagElement  = $('.cart-nav')
    $.ajax({
    type: 'GET',
    url: '/refresh_cart_bag.js',
    }).done(function () {
    }).fail(function (response) {
    })
  e.preventDefault();
});

$(document).ready(function() {
  $(document).on("click" , ".close-sidebar-btn", function(e){  
    $('.cart-sidebar').toggleClass("active");
    $('.overlay').toggleClass("active");
    $('body').toggleClass("hide-scroll");
  e.preventDefault();
  });
  $(document).on("click",function() {
   if ($('.cart-sidebar').hasClass("active")){
    $('.cart-sidebar').toggleClass("active");
    $('.overlay').toggleClass("active");
    $('body').toggleClass("hide-scroll");
  e.preventDefault();
   }
});

  $('.cart-sidebar-wrapper .overlay').on('click', function(e) {
    $('.nav-cart').toggleClass("active");
    $('.cart-sidebar').toggleClass("active");
    $('.cart-sidebar-wrapper .overlay').toggleClass("active");
    $('body').removeClass("hide-scroll");
    e.preventDefault();
  });

});
