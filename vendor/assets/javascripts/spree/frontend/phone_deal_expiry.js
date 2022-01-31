document.addEventListener('turbolinks:before-render', () => {
    var SalesExpiryDatePhone= $('#DealsExpiryPhone').attr("data-SalesExpiryDatePhone");
    var countDownDatePhone = new Date(SalesExpiryDatePhone).getTime();
    var x = setInterval(function() {
      var now = new Date().getTime();
      var distance = countDownDatePhone - now;
      var days = Math.floor(distance / (1000 * 60 * 60 * 24));
      var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);
    
      $('#DealsExpiryPhone').html("<strong>Deal Expiers in: <span>" + days + "</strong> day </span><span><strong>" + hours + "</strong> hours </span><strong><span>"
      + seconds + "</strong> seconds </span> ")
         
      if (distance < 0) {
        clearInterval(x);
        $('#DealsExpiryPhone').html(" Expired ")
      }
    }, 1000);
    });