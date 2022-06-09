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

  $(".js-variant-list").click(function(){
    let selected_variant_sku = $(this).data("varient-sku")
    $("#js_selected_variantt_sku").html(selected_variant_sku)
  })

  $(".option-values-dropdown").click()
  $('body').click()

  if ($(".color-select-label")[0] != null ){
    $(".color-select-label")[0].click()
  }

  let selected_option_value = $(".js_option_value_list input:radio:not(:disabled)")[0]
  let selected_value_presentation = $(selected_option_value).data("presentation")

  $(selected_option_value).click()

  let option_type_id = "." + $(selected_option_value).data("option-type-id")
  $(option_type_id).html(selected_value_presentation)
});
