$( document ).on('turbolinks:load', function() {
  $(".js-selected-label-color").click(function() {
    let value = $(this).html()
    $(".js_color_value").html(value)
  });
  $(".js_select_option_value").click(function() {
    let value = $(this).html()
    let data_id = $(this).data("dropdown-value-id")
    $(".js_option_value_"+ data_id).html(value)
  });
  $(".option-values-dropdown").click()
  $('body').click()
});
