//= require spree/frontend

function gaAddToCart(variant, product, quantity, currency) {
  var price = typeof variant.price === 'object' ? variant.price.amount : variant.price

  var item_variant = "";
  var option_values = variant.option_values;
  for(let i = 0; i < option_values.length; i++) {
    let opt_val = option_values[i];
    if (i == 0) {
      item_variant = opt_val.name;
    } else {
      item_variant = item_variant + ', ' + opt_val.name;
    }
  }
  var item_name = (product.name + ' ' + item_variant).trim();

  gtag('event', 'add_to_cart', {
    currency: currency,
    value: price * quantity,
    items: [{
      item_id: variant.sku,
      item_name: item_name,
      item_variant: item_variant,
      price: price,
      quantity: quantity
    }]
  });
}

Spree.ready(function($) {
  $('body').on('product_add_to_cart', function(event) {
    var variant = event.variant;
    var product = event.product;
    var quantity = event.quantity_increment;
    var currency = event.cart.currency;

    gaAddToCart(variant, product, quantity, currency);
  })
});
