//= require spree/api/main

SpreeAPI.Storefront.createCart = function (successCallback, failureCallback) {
  fetch(Spree.routes.api_v2_storefront_cart_create, {
    method: 'POST',
    headers: SpreeAPI.prepareHeaders()
  }).then(function (response) {
    switch (response.status) {
      case 422:
        response.json().then(function (json) { failureCallback(json.error) })
        break
      case 500:
        SpreeAPI.handle500error()
        break
      case 201:
        response.json().then(function (json) {
          SpreeAPI.orderToken = json.data.attributes.token
          successCallback()
        })
        break
    }
  })
}

SpreeAPI.Storefront.addToCart = function (variantId, quantity, options, successCallback, failureCallback) {
  fetch(Spree.routes.api_v2_storefront_cart_add_item, {
    method: 'POST',
    headers: SpreeAPI.prepareHeaders({ 'X-Spree-Order-Token': SpreeAPI.orderToken }),
    body: JSON.stringify({
      variant_id: variantId,
      quantity: quantity,
      options: options
    })
  }).then(function (response) {
    switch (response.status) {
      case 422:
        response.json().then(function (json) { failureCallback(json.error) })
        break
      case 500:
        SpreeAPI.handle500error()
        break
      case 200:
        response.json().then(function (json) {
          // successCallback(json.data)
          var addToCartButton = document.getElementById('add-to-cart-button')
          var cartBagElement  = $('.cart-nav')
          cartForm(json.data.attributes.number, json.data.attributes.token);

          // Trigger product_add_to_cart event for GA
          var addToCartForn = $(document.getElementById('add-to-cart-form'));
          addToCartForn.trigger({
            type: 'product_add_to_cart',
            variant: Spree.variantById(addToCartForn, variantId),
            product: Spree.getCartProduct(addToCartForn),
            quantity_increment: quantity,
            cart: json.data
          });
          
          $.ajax({
            type: 'GET',
            url: '/refresh_cart_bag.js',
          }).done(function () {
            cartBagElement.click();
            addToCartButton.removeAttribute('disabled')
          }).fail(function (response) {
          })

        })
        break
    }
  })
}