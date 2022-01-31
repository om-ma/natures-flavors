$( document ).ready(function() {
  $('.sub-child-manu-js').click(function (e) {
     var child_link = $(this).find('a').attr('href');
     var url = window.location.origin;
     window.location.href = url + child_link;

    });
 $(".product-sort-js").click(function(){
      var click_filter = $(this).data("filter-type");
      $("." + click_filter)[0].click();
    });


   $('.mobile-category-toggle').on('click', function(e) {
    $('.mobile-category-toggle').toggleClass("clicked");
    $('.sidebar-sub-categories').toggleClass("show");
    e.preventDefault();
  });

   
 $('.filter-btn').on('click', function(e) {
    $('.category-mobile-filter').toggleClass("open");
    $('.shop-by-filter-mobile').toggleClass("show");
    e.preventDefault();
  });

});

 
 

   
 