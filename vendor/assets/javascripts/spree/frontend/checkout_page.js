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

	$(".js_user_credit_card_save").on('click',function(){
		if (this.checked){
			$(".spree-gateway-authorizenetcim").removeClass("d-none")
			$(".spree-gateway-authorizenet").addClass("d-none")
			$(".spree-gateway-authorizenetcim").click();
			$(".save_user_card").removeClass("d-none")
			$(".spree-gateway-authorizenetcim").click();
			$(".js_user_credit_card_save").prop("checked", true);

		}else{
			$(".spree-gateway-authorizenetcim").addClass("d-none")
			$(".spree-gateway-authorizenet").removeClass("d-none")
			$(".spree-gateway-authorizenet").click();
			$(".save_user_card").addClass("d-none")
			$(".js_user_credit_card_save").prop("checked", false);
			$('.spree-gateway-authorizenet-card-num').payment('formatCardNumber')
			$('.spree-gateway-authorizenet-card-expiry').payment('formatCardExpiry')
			$('.spree-gateway-authorizenet-card-code').payment('formatCardCVC')
		}
	});
	
	
});
