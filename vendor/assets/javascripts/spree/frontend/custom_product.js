$(document).on('turbolinks:load', function() {

  $(document).ready(function() {
    $('.product-ov-js').on('click', function(e) {
      $('.product-ov-js').removeClass("active");
      $(this).addClass('active')
      var variantSku = $(this).attr("data-varient-sku");
      $("#product_variant_sku").replaceWith(
        "<div id = 'product_variant_sku'>" + variantSku + "</div>"
      );
      var variantPrice = $(this).attr("data-btn-varient-price");
      $("#product_btn_variant_price").replaceWith(
        "<span id = 'product_btn_variant_price'>" + variantPrice + "</span>"
      );
      var variantId = $(this).attr("data-varient-id");
      $('#variant_id_'+ variantId ).click();
    });
  });

  $(document).ready(function() {
    $('.close-menu').on('click', function(e) {
      $('.mobile-menu').toggleClass("show");
      e.preventDefault();
    });

    $('.sub-menu > li').click(function(e){
      e.stopPropagation();
    $(this).toggleClass('active');
      $(this).children('div').slideToggle();
      $(this).closest('.parent').siblings().children('div').slideUp();
    });


  $(document).ready(function() {
    $('#videos-slider').lightSlider({
        item: 2,
        loop: false,
        slideMove: 1,
        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
        speed: 600,
    slideMargin: 120,
    enableTouch: true,
    pager: false,
    onSliderLoad: function (el) {
      var parent = el.parent();
      var action = parent.find('.lSAction');
      action.insertBefore(parent);
      },
        responsive : [
        {
          breakpoint:1199,
          settings: {
            slideMargin: 40,
          }
        },
        {
          breakpoint:991,
          settings: {
            item:2,
            slideMove:1,
            slideMargin: 30
          }
        },
        {
          breakpoint:575,
          settings: {
            item:1,
            slideMargin:20
          }
        }
      ]
    });
  });

  $(document).ready(function() {
    $('#blog-slider').lightSlider({
        item: 2,
        loop: false,
        slideMove: 1,
        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
        speed: 600,
    slideMargin: 120,
    enableTouch: true,
    pager: false,
        onSliderLoad: function (el) {
      var parent = el.parent();
      var action = parent.find('.lSAction');
      action.insertBefore(parent);
      },
        responsive : [
        {
          breakpoint:1199,
          settings: {
            slideMargin: 40,
          }
        },
        {
          breakpoint:991,
          settings: {
            item: 2,
            slideMove: 1,
            slideMargin: 30
          }
        },
        {
          breakpoint:575,
          settings: {
            item: 1,
            slideMargin: 20
          }
        }
      ]
    });
  });

  $(document).ready(function() {
    $('#reviews-slider').lightSlider({
        item: 3,
        loop: false,
        slideMove: 1,
        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
        speed: 600,
    slideMargin: 0,
    enableTouch: true,
    pager: false,
        onSliderLoad: function (el) {
      var parent = el.parent();
      var action = parent.find('.lSAction');
      action.insertBefore(parent);
      },
        responsive : [
        {
          breakpoint:1199,
          settings: {
            item: 2,
            slideMove: 1,
          }
        },
        {
          breakpoint:767,
          settings: {
            item: 1,
            slideMove: 1,
          }
        }
      ]
    });
  });

  $(document).ready(function() {
    $('.nav-cart').on('click', function(e) {
      $('.nav-search').removeClass('active');
      $('.mobile-search-menu').removeClass('active');
      $('.mobile-menu').removeClass('show');
      $('.sidebar-menu-wrapper .overlay').removeClass('active');
      // actual function
      $('.mobile-menu-link').addClass('collapsed');
      $('.cart-sidebar').toggleClass("active");
      $('.nav-cart').toggleClass("active");
      $('.cart-sidebar-wrapper .overlay').toggleClass("active");
      $('body').removeClass("hide-scroll");
    e.preventDefault();
    });

    $('.close-sidebar-btn').on('click', function(e) {
      $('.nav-cart').toggleClass("active");
      $('.cart-sidebar').toggleClass("active");
      $('.cart-sidebar-wrapper .overlay').toggleClass("active");
      $('body').removeClass("hide-scroll");
    e.preventDefault();
    });

    $('.cart-sidebar-wrapper .overlay').on('click', function(e) {
      $('.nav-cart').toggleClass("active");
      $('.cart-sidebar').toggleClass("active");
      $('.cart-sidebar-wrapper .overlay').toggleClass("active");
      $('body').removeClass("hide-scroll");
    e.preventDefault();
    });

    $('.mobile-menu-link').on('click', function(e) {
      $('.nav-search').removeClass('active');
      $('.mobile-search-menu').removeClass('active');
      $('.nav-cart').removeClass('active');
      $('.cart-sidebar').removeClass('active');
      $('.cart-sidebar-wrapper .overlay').removeClass('active');
      $('body').removeClass("hide-scroll");
    });

    $('.nav-search').on('click', function(e) {
      if($('.nav-cart').hasClass('active')){
        $('.nav-cart').removeClass('active');
      }
      if($('.cart-sidebar').hasClass('active')){
        $('.cart-sidebar').removeClass('active');
      }
      if($('.cart-sidebar-wrapper .overlay').hasClass('active')){
        $('.cart-sidebar-wrapper .overlay').removeClass('active');
      }
      if($('.mobile-menu').hasClass('show')){
        $('.mobile-menu').removeClass('show');
      }
      $('.mobile-menu-link').addClass('collapsed');
      $('.mobile-search-menu').toggleClass("active");
      $('.nav-search').toggleClass("active");
    e.preventDefault();
    });
  });


  $(document).ready(function() {
    $('#product-gallery').lightSlider({
    gallery: true,
        item:1,
        loop:false,
    controls: false,
        slideMove:1,
        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
        speed:600,
    slideMargin:0,
    enableTouch: true,
    pager: true,
    thumbItem: 3,
        responsive : [
        {
          breakpoint:991,
          settings: {
            auto: true,
            loop: true,
          }
        },
      ]
    });
  })
  });
});
$(document).ready(function() {
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  });
});

