$( document ).ready(function() {
    $('select').on('change', function() {
      if (this.value == "new-address"){
        $(".shipping_new_address").click();
      }
    });
    $('select').on('change', function() {
       var danish= this.value;
        $('#'+danish).click();
      });
  });
  
