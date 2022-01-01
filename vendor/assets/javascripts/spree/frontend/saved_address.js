$(document).ready(function() {
    $('.address-select-change-js').on('change', function() {
      if (this.value == "new_address_selected"){
        $("#order_bill_address_id_0").click();
      }
      else{
          let selectedAddress_id = this.value
          $("." + selectedAddress_id)[0].click();
      }
    });
});
