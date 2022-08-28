$(document).on('turbolinks:load', function () {
  $('.product-ov-js').on('click', function (e) {
     $('.product-ov-js').removeClass("active");
     $(this).addClass('active')
     var variantSku = $(this).attr("data-variant-sku");
     var variantPrice = $(this).attr("data-btn-variant-price");
     var variantId = $(this).attr("data-variant-id");

     $('#selected_variant').val(variantId);
     $('#variant_id').val(variantId);
     
     $('.add-to-cart-button').removeAttr("disabled");
  });
});

$(document).ready(function () {
  $('.close-menu').on('click', function (e) {
     $('.mobile-menu').toggleClass("show");
     e.preventDefault();
  });

  $('.sub-menu > li').click(function (e) {
     e.stopPropagation();
     $(this).toggleClass('active');
     $(this).children('div').slideToggle();
     $(this).closest('.parent').siblings().children('div').slideUp();
  });

});

$(document).on('turbolinks:load', function () {
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
     responsive: [{
           breakpoint: 1199,
           settings: {
              slideMargin: 40,
           }
        },
        {
           breakpoint: 991,
           settings: {
              item: 2,
              slideMove: 1,
              slideMargin: 30
           }
        },
        {
           breakpoint: 575,
           settings: {
              item: 1,
              slideMargin: 20
           }
        }
     ]
  });
});

$(document).on('turbolinks:load', function () {
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
     responsive: [{
           breakpoint: 1199,
           settings: {
              slideMargin: 40,
           }
        },
        {
           breakpoint: 991,
           settings: {
              item: 2,
              slideMove: 1,
              slideMargin: 30
           }
        },
        {
           breakpoint: 575,
           settings: {
              item: 1,
              slideMargin: 20
           }
        }
     ]
  });
});

$(document).on('turbolinks:load', function () {
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
     responsive: [{
           breakpoint: 1199,
           settings: {
              item: 2,
              slideMove: 1,
           }
        },
        {
           breakpoint: 767,
           settings: {
              item: 1,
              slideMove: 1,
           }
        }
     ]
  });
});

$(document).on('turbolinks:load', function () {
  $('.nav-cart').on('click', function (e) {
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

  $('.cart-sidebar-wrapper .overlay').on('click', function (e) {
     $('.nav-cart').toggleClass("active");
     $('.cart-sidebar').toggleClass("active");
     $('.cart-sidebar-wrapper .overlay').toggleClass("active");
     $('body').removeClass("hide-scroll");
     e.preventDefault();
  });

  $('.close-menu-link').on('click', function (e) {
     $('.mobile-menu').toggleClass("show");
     $('.nav-cart').removeClass('active');
     $('body').removeClass("hide-scroll");
     e.preventDefault();
  });

  $('.mobile-menu-link').on('click', function (e) {
     $('.nav-cart').removeClass('active');
     $('.cart-sidebar').removeClass('active');
     $('.cart-sidebar-wrapper .overlay').removeClass('active');
     $('body').removeClass("hide-scroll");
     e.preventDefault();
  });

});

$(document).on('turbolinks:load', function () {
  $(function () {
     $('[data-toggle="tooltip"]').tooltip()
  });
});
$(document).on('turbolinks:load', function () {
  $('#product-gallery').lightSlider({
     gallery: true,
     item: 1,
     loop: false,
     controls: false,
     slideMove: 1,
     easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
     speed: 600,
     slideMargin: 0,
     enableTouch: true,
     pager: true,
     thumbItem: 3,
     responsive: [{
        breakpoint: 991,
        settings: {
           slideMove: 1,
           auto: false,
           loop: true,
        }
     }, ]
  });
});