$( document ).ready(function() {
  $('.sub-child-manu-js').click(function (e) {
     var child_link = $(this).find('a').attr('href');
     var url = window.location.origin;
     window.location.href = url + child_link;

    });

    $(document).on('click', '.product-sort-js', function(){
    	e.preventDefault();
    	var click_filter = $(this).data("filter-type");
     	$("." + click_filter)[0].click();
    })

});

 

