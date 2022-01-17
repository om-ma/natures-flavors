var SalesExpiryDatePhone= $('#DealsExpiryPhone').attr("data-SalesExpiryDatePhone");
var countDownDatePhone = new Date(SalesExpiryDatePhone).getTime();
var x = setInterval(function() {
  var now = new Date().getTime();
  var distancePhone = countDownDatePhone - now;
  var daysPhone = Math.floor(distance / (1000 * 60 * 60 * 24));
  var hoursPhone = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutesPhone = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var secondsPhone = Math.floor((distance % (1000 * 60)) / 1000);

  $('#DealsExpiryPhone').html("<strong>Deal Expiers in: <span>" + daysPhone + "</strong> day </span><span><strong>" + hoursPhone + "</strong> hours </span><strong><span>"
  + secondsPhone + "</strong> seconds </span> ")
     
  if (distance < 0) {
    clearInterval(x);
    $('#DealsExpiryPhone').html(" Expired ")
  }
}, 1000);
