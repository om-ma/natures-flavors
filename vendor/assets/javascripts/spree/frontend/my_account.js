$(document).ready(function() {
  jQuery(document).ready(function() {
    jQuery('.show-order-details').click(function(event) {
      jQuery(event.target).closest('.order-row-wrap').toggleClass('show');
    });
});	
});