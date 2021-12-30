$(document).ready(function() {
  AOS.init();

  const slinky = $('#menu').slinky({title:true});

  $(function () {
    $('[data-toggle="popover"]').popover();
  })
</script> 
<script>
  $('.close-menu').on('click', function(e) {
    $('.mobile-menu').toggleClass("show");
    e.preventDefault();
  });

  $('.sub-menu > li').click(function(e){
    e.stopPropagation();
  $(this).toggleClass('active');
    $(this).children('div').slideToggle();
    $(this).closest('.parent').siblings().children('div').slideUp();
  });
</script> 
<script>
  $(document).ready(function() {
    $('#videos-slider').lightSlider({
        item: 2,
        loop: false,
        slideMove: 1,
        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
        speed: 600,
    slideMargin: 120,
    enableTouch: true,
    pager: false,
    onSliderLoad: function (el) {
      var parent = el.parent();
      var action = parent.find('.lSAction');
      action.insertBefore(parent);
      },
        responsive : [
        {
          breakpoint:1199,
          settings: {
            slideMargin: 40,
          }
        },
        {
          breakpoint:991,
          settings: {
            item:2,
            slideMove:1,
            slideMargin: 30
          }
        },
        {
          breakpoint:575,
          settings: {
            item:1,
            slideMargin:20
          }
        }
      ]
    });
  });

  $(document).ready(function() {
    $('#blog-slider').lightSlider({
        item: 2,
        loop: false,
        slideMove: 1,
        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
        speed: 600,
    slideMargin: 120,
    enableTouch: true,
    pager: false,
        onSliderLoad: function (el) {
      var parent = el.parent();
      var action = parent.find('.lSAction');
      action.insertBefore(parent);
      },
        responsive : [
        {
          breakpoint:1199,
          settings: {
            slideMargin: 40,
          }
        },
        {
          breakpoint:991,
          settings: {
            item: 2,
            slideMove: 1,
            slideMargin: 30
          }
        },
        {
          breakpoint:575,
          settings: {
            item: 1,
            slideMargin: 20
          }
        }
      ]
    });
  });  

  $(document).ready(function() {
    $('#reviews-slider').lightSlider({
        item: 3,
        loop: false,
        slideMove: 1,
        easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
        speed: 600,
    slideMargin: 0,
    enableTouch: true,
    pager: false,
        onSliderLoad: function (el) {
      var parent = el.parent();
      var action = parent.find('.lSAction');
      action.insertBefore(parent);
      },
        responsive : [
        {
          breakpoint:1199,
          settings: {
            item: 2,
            slideMove: 1,
          }
        },
        {
          breakpoint:767,
          settings: {
            item: 1,
            slideMove: 1,
          }
        }
      ]
    });
  });  

  $('.nav-cart').on('click', function(e) {
    $('.nav-search').removeClass('active');
    $('.mobile-search-menu').removeClass('active');
    $('.mobile-menu').removeClass('show');
    $('.sidebar-menu-wrapper .overlay').removeClass('active');
    // actual function
    $('.mobile-menu-link').addClass('collapsed');
    $('.cart-sidebar').toggleClass("active");
    $('.nav-cart').toggleClass("active");
    $('.cart-sidebar-wrapper .overlay').toggleClass("active");
    $('body').removeClass("hide-scroll");
  e.preventDefault();
  });
    
  $('.close-sidebar-btn').on('click', function(e) {
    $('.nav-cart').toggleClass("active");
    $('.cart-sidebar').toggleClass("active");
    $('.cart-sidebar-wrapper .overlay').toggleClass("active");
    $('body').removeClass("hide-scroll");
  e.preventDefault();
  });
    
  $('.cart-sidebar-wrapper .overlay').on('click', function(e) {
    $('.nav-cart').toggleClass("active");
    $('.cart-sidebar').toggleClass("active");
    $('.cart-sidebar-wrapper .overlay').toggleClass("active");
    $('body').removeClass("hide-scroll");
  e.preventDefault();
  });

  $('.mobile-menu-link').on('click', function(e) {
    $('.nav-search').removeClass('active');
    $('.mobile-search-menu').removeClass('active');
    $('.nav-cart').removeClass('active');
    $('.cart-sidebar').removeClass('active');
    $('.cart-sidebar-wrapper .overlay').removeClass('active');
    $('body').removeClass("hide-scroll");
  });

  $('.nav-search').on('click', function(e) {
    if($('.nav-cart').hasClass('active')){
      $('.nav-cart').removeClass('active');
    }
    if($('.cart-sidebar').hasClass('active')){
      $('.cart-sidebar').removeClass('active');
    }
    if($('.cart-sidebar-wrapper .overlay').hasClass('active')){
      $('.cart-sidebar-wrapper .overlay').removeClass('active');
    }
    if($('.mobile-menu').hasClass('show')){
      $('.mobile-menu').removeClass('show');
    }
    $('.mobile-menu-link').addClass('collapsed');
    $('.mobile-search-menu').toggleClass("active");
    $('.nav-search').toggleClass("active");
  e.preventDefault();
  });


canvas = document.getElementById("canvas");
ctx = canvas.getContext("2d");
canvas.width = window.innerWidth;
canvas.height = window.innerHeight;
cx = ctx.canvas.width/2;
cy = ctx.canvas.height/2;

let confetti = [];
const confettiCount = 60;
const gravity = 0.5;
const terminalVelocity = 5;
const drag = 0.075;
const colors = [
  { front : '#c6eae9', back: '#c6eae9'},
  { front : '#ee6f57', back: '#ee6f57'},
  { front : '#d3dfff', back: '#d3dfff'},
  { front : '#708cd5', back: '#708cd5'},
  { front : '#f5c7be', back: '#f5c7be'},
  { front : '#f5c7be', back: '#f5c7be'},
];

//-----------Functions--------------
resizeCanvas = () => {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  cx = ctx.canvas.width/2;
  cy = ctx.canvas.height/2;
}

randomRange = (min, max) => Math.random() * (max - min) + min

initConfetti = () => {
  for (let i = 0; i < confettiCount; i++) {
    confetti.push({
      color      : colors[Math.floor(randomRange(0, colors.length))],
      dimensions : {
        x: randomRange(10, 20),
        y: randomRange(10, 30),
      },
      position   : {
        x: randomRange(0, canvas.width),
        y: canvas.height - 1,
      },
      rotation   : randomRange(0, 2 * Math.PI),
      scale      : {
        x: 1,
        y: 1,
      },
      velocity   : {
        x: randomRange(-25, 25),
        y: randomRange(0, -50),
      },
    });
  }
}

render = () => {  
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  
  confetti.forEach((confetto, index) => {
    let width = (confetto.dimensions.x * confetto.scale.x);
    let height = (confetto.dimensions.y * confetto.scale.y);
    
    // Move canvas to position and rotate
    ctx.translate(confetto.position.x, confetto.position.y);
    ctx.rotate(confetto.rotation);
    
    // Apply forces to velocity
    confetto.velocity.x -= confetto.velocity.x * drag;
    confetto.velocity.y = Math.min(confetto.velocity.y + gravity, terminalVelocity);
    confetto.velocity.x += Math.random() > 0.5 ? Math.random() : -Math.random();
    
    // Set position
    confetto.position.x += confetto.velocity.x;
    confetto.position.y += confetto.velocity.y;
    
    // Delete confetti when out of frame
    if (confetto.position.y >= canvas.height) confetti.splice(index, 1);

    // Loop confetto x position
    if (confetto.position.x > canvas.width) confetto.position.x = 0;
    if (confetto.position.x < 0) confetto.position.x = canvas.width;

    // Spin confetto by scaling y
    confetto.scale.y = Math.cos(confetto.position.y * 0.1);
    ctx.fillStyle = confetto.scale.y > 0 ? confetto.color.front : confetto.color.back;
     
    // Draw confetto
    ctx.fillRect(-width / 2, -height / 2, width, height);
    
    // Reset transform matrix
    ctx.setTransform(1, 0, 0, 1, 0, 0);
  });

  // Fire off another round of confetti
  //if (confetti.length <= 10) initConfetti();

  window.requestAnimationFrame(render);
}

//---------Execution--------
initConfetti();
render();

//----------Resize----------
window.addEventListener('resize', function () {
  resizeCanvas();
});
});