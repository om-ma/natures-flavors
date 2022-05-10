$( document ).on('turbolinks:load', function() {
	$(".design-submit-next-step").on('click',function(){
		$("#checkout-submit-to-next-step").click();
	});

	$('.show-cart-summary').on('click', function(e) {
	    $('.show-cart-summary').toggleClass("clicked");
	    $('.mobile-cart-summary').toggleClass("show");
	    e.preventDefault();
	});
	
	$("#is_user_address_saved").on('change',function(){
		if (this.checked){
			$("#save_user_address").val("true")
		}else{
			$("#save_user_address").replaceWith("");
		}
	});
});		