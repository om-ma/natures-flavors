$( document ).on('turbolinks:load', function() {
  $('.search-custom-btn').on('click',function(){
    $("#global-search-button").submit()
  })
});
