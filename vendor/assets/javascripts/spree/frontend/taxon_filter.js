$( document ).ready(function() {
  $('.sub-child-manu-js').click(function (e) {
     var child_link = $(this).find('a').attr('href');
     var url = window.location.origin;
     window.location.href = url + child_link;

    });
});