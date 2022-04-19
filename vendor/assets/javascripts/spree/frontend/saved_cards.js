 $(document).ready(function(){
    $('.cards-select-change-js').on('change', function() {
      if (this.value == "new_card_selected"){
        $("#use_existing_card_no").click();
      }
      else{
         let selectedCard_id = this.value
          $("#" + selectedCard_id)[0].click();
      }
    });
});