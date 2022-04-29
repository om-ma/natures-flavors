$( document ).on('turbolinks:load', function() {
    $('.show-order-details').click(function(event) {
      $(event.target).closest('.order-row-wrap').toggleClass('show');
    });
});