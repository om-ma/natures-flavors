//= require spree/frontend

function gaViewItem(variants, product, currency) {
  var items = new Array();

  for(let i = 0; i < variants.length; i++) {
    let variant = variants[i];
    let price = typeof variant.price === 'object' ? variant.price.amount : variant.price

    let item_variant = "";
    let option_values = variant.option_values;
    for( let i = 0; i < option_values.length; i++) {
      let opt_val = option_values[i];
      if (i == 0) {
        item_variant = opt_val.name;
      } else {
        item_variant = item_variant + ', ' + opt_val.name;
      }
    }
    let item_name = (product.name + ' ' + item_variant).trim();
    let item = {
      item_id: variant.sku,
      item_name: item_name,
      item_variant: item_variant,
      price: price
    };
    items.push(item);
  }

  var price = typeof variants[0].price === 'object' ? variants[0].price.amount : variants[0].price

  gtag('event', 'view_item', {
    currency: currency,
    value: price,
    items: items
  });
}

Spree.ready(function($) {
  $('body').on('product_view_item', function(event) {

    var variants = event.variants;
    var product = event.product;
    var currency = event.currency;

    gaViewItem(variants, product, currency);
  })
});
