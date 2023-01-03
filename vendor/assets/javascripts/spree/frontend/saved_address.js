$( document ).on('turbolinks:load', function() {
    $('.address-select-change-js').on('change', function() {
      if (this.value == "new_address_selected") {
        $("#order_ship_address_id_0").click();
        $('#shipping').find('input:text').val('');
        if ($("#is_user_address_saved").is(':checked')) {
          $("#save_user_address").val("true");
        } else {
          $("#save_user_address").val("false");
        }
      } else {
          let selectedAddress_id = this.value
          $("." + selectedAddress_id)[0].click();
      }
    });

    $('.billing-address-select-change-js').on('change', function() {
      if (this.value == "new_address_selected") {
        $("#order_bill_address_id_0").click();
        $('#billing').find('input:text').val('');
        if ($("#is_user_address_saved").is(':checked')) {
          $("#save_user_address").val("true");
        } else {
          $("#save_user_address").val("false");
        }
      } else {
        let selectedAddress_id = this.value
        $("." + selectedAddress_id)[0].click();
      }
    });
});
