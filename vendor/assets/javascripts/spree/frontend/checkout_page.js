$( document ).on('turbolinks:load', function() {
	$(".design-submit-next-step").on('click',function(){
		$("#checkout-submit-to-next-step").click();
	});

	$('.show-cart-summary').on('click', function(e) {
	    $('.show-cart-summary').toggleClass("clicked");
	    $('.mobile-cart-summary').toggleClass("show");
	    e.preventDefault();
	});
	
	if ($("#is_user_address_saved").is(':checked') == false) {
		$(".save_address_as_default").attr("disabled", true);
		$(".save_address_as_default").prop("checked", false);
	}
	
	$("#is_user_address_saved").on('change',function(){
		if (this.checked){
			$("#save_user_address").val("true");
			$(".save_address_as_default").removeAttr("disabled");
		}else{
			$("#save_user_address").val("false");
			$(".save_address_as_default").attr("disabled", true);
			$(".save_address_as_default").prop("checked", false);
		}
	});

	$(".js_user_credit_card_save").on('click',function(){
		if (this.checked){
			$(".cards-select-change-js").show()
			$(".spree-gateway-authorizenetcim").removeClass("d-none")
			$(".spree-gateway-authorizenet").addClass("d-none")
			$(".spree-gateway-authorizenetcim").click();
			$(".save_user_card").removeClass("d-none")
			$(".spree-gateway-authorizenetcim").click();
			$(".js_user_credit_card_save").prop("checked", true);
			let first_card = $(".cards-select-change-js").children()[0]
			$(".cards-select-change-js").val($(first_card).val())

		}else{
			$(".cards-select-change-js").hide()
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

	$("#spree-gateway-paypalexpress-new").on('click',function(){
		$("#paypal_button")[0].click();
	});
	
	
});
