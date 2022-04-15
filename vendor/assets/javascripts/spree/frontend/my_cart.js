
function cartForm(orderNumber, token) {

  let that = this;
  this.orderForm = $('form#product_cart_form');
  this.lineItems = [];
  this.tok = $('.cart-line-items').data('order-tok');
  this.orderResponse = null;
  this.newLineItem = null;
  this.orderNum = orderNumber;
  this.orderToken = token;
  this.lineItemId = $('.js-line-item-change').data('js-line-item-id');
  this.render = function (order) {
    this.updateSummaryGeneral(order);
    this.updatePopup(order);
  }

  this.updateItem = function (item, action, qtyChange, cb) {
    let parentRow = $(item).parents('.line-item').first();
    let lineItemId = $(parentRow).data('lineitem-id');
    const $vendorBox = $($(item).parents('.sip-box').first());
    let orderNum = that.orderNum;
    let orderToken = that.orderToken;
    let data = {user_id: '', order: {line_items_attributes: [{quantity: qtyChange, id: lineItemId}]}};
    $.ajax({
      url: "/api/v1/orders/" + orderNum + "?order_token=" + orderToken,
      type: 'PUT',
      contentType: 'application/x-www-form-urlencoded',
      data: data,
      success: function (result) {
        if (qtyChange === 0) {
          $(parentRow).remove();
          $('.cart-line-item-container-'+lineItemId).addClass('deleted');
          $('.cart-line-item-container-'+lineItemId).remove();
          $('.cart-item-count').html($('.cart-line-item-container').not('.deleted').length);
          if ($('.shopping-cart-item').length == 0){
            $('.empty-cart-area').html('<div class="d-flex flex-column justify-content-between h-100"><div class="d-flex flex-column align-items-center"><svg xmlns="http://www.w3.org/2000/svg" height="83px" viewBox="0 0 82.644 91.651" width="83px" class="spree-icon shopping-cart-empty-image"><g fill="currentColor"><path d="m105.3 120.583a2.97 2.97 0 0 0 2.95 2.664 3.012 3.012 0 0 0 .309-.016 2.969 2.969 0 0 0 2.648-3.258l-1.369-13.249a2.969 2.969 0 0 0 -5.906.61z" transform="translate(-67.283 -62.867)"></path><path d="m150.285 123.23a3.012 3.012 0 0 0 .309.016 2.969 2.969 0 0 0 2.95-2.664l1.369-13.249a2.969 2.969 0 0 0 -5.907-.61l-1.369 13.249a2.969 2.969 0 0 0 2.648 3.258z" transform="translate(-93.687 -62.867)"></path><path d="m82.253 185.088a9.191 9.191 0 1 0 9.19 9.19 9.2 9.2 0 0 0 -9.19-9.19zm0 12.444a3.253 3.253 0 1 1 3.252-3.254 3.257 3.257 0 0 1 -3.252 3.254z" transform="translate(-48.644 -111.819)"></path><path d="m159.693 185.088a9.191 9.191 0 1 0 9.191 9.19 9.2 9.2 0 0 0 -9.191-9.19zm0 12.444a3.253 3.253 0 1 1 3.253-3.254 3.257 3.257 0 0 1 -3.253 3.254z" transform="translate(-95.428 -111.819)"></path><path d="m93.4 59.345a2.969 2.969 0 0 0 -2.349-1.153h-59.179l-2.485-9.556a2.969 2.969 0 0 0 -2.874-2.222h-12.168a2.969 2.969 0 0 0 0 5.938h9.873l2.465 9.479c.012.053.026.106.041.158l9.167 35.25a2.969 2.969 0 0 0 2.874 2.222h43.1a2.969 2.969 0 0 0 2.874-2.222l9.188-35.33a2.97 2.97 0 0 0 -.527-2.564zm-13.833 34.178h-38.507l-7.644-29.393h53.8z" transform="translate(-11.376 -28.041)"></path><path d="m89.978 30.872a2.969 2.969 0 1 0 4.2-4.2l-9.337-9.333a2.969 2.969 0 0 0 -4.2 4.2z" transform="translate(-52.696 -9.95)"></path><path d="m154.643 31.742a2.96 2.96 0 0 0 2.1-.87l9.323-9.332a2.969 2.969 0 0 0 -4.2-4.2l-9.323 9.332a2.969 2.969 0 0 0 2.1 5.067z" transform="translate(-96.136 -9.952)"></path><path d="m130.476 19.124a2.969 2.969 0 0 0 2.969-2.968v-13.186a2.969 2.969 0 0 0 -2.964-2.97 2.969 2.969 0 0 0 -2.969 2.968v13.186a2.969 2.969 0 0 0 2.964 2.97z" transform="translate(-81.536)"></path></g></svg><p class="text-center shopping-cart-empty-info">Your cart is empty.</p></div><a class="btn btn-primary text-uppercase font-weight-bold shopping-cart-empty-continue-link btn-color" href="/products">Continue shopping</a></div>');
            $('.cart-summary').html('') /* Empty Cart Summary Area */
            window.location = '/cart' /* Redirect To Cart Page if no item exists in cart */
          }
          if (!$vendorBox.find('.line-item').length) {

            $vendorBox.addClass('deleted');
            $vendorBox.remove();
            if(!$('.sip-box').not('.deleted').length){
              $('.items_cart_list').html(`<li><table class="table table-striped">
                                  <tbody><tr>
                                        <td class="text-center" style="width:70px">
                                          <%= Spree.t('header_cart.empty_items') %>
                                        </td>
                                      </tr> </tbody></table></li> `);
              $('.cart-cta').html();
            }

          }
        }
        let new_str_count =qtyChange
        if(new_str_count.toString().length == 1){
          new_str_count = '0'+ new_str_count.toString()
        }
        that.updateVendorSummary(item, result);

      },
      error: function (xhr, ajaxOptions, thrownError,status) {
        $('.app-loader').hide();
        let response = xhr.responseJSON;
        toastr.error(xhr.responseText);
      }

    });
  };

  this.updateVendorSummary = function (item, order) {
    const vendorBox = $(item).parents('.sip-box').first();
    const vendorId = $(vendorBox).data('vendor-id');
    const renderAlignShipmentNum = () => {
      let allBoxes = $('.sip-box').not('.deleted');
      $.each(allBoxes, function (index, el) {
        let lis = $(el).find('.line-item');
        let totalPrice = 0;
        let totalCount = 0;
        let displayPrice = '';
        $.each(lis, function (index, liEl) {
          let {liCount,liPrice,liCurrency} = boxSingleItem(liEl);

          totalPrice += (liCount * liPrice);
          totalCount += liCount;
          liCurrency = liCurrency.replace(/,/, "");

          if (lis.length === index + 1) {
            if (liCurrency == "$"){
              displayPrice =  liCurrency + ' ' + totalPrice.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }else{
              displayPrice = totalPrice.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' ' + liCurrency;
            }
          }
        })
      })
    }
    sum = 0;
    Object(order).line_items && order.line_items.forEach((li) => {
        let costs = li.display_amount;
        let itemCount = li.quantity;
        renderItemTotalPrice(costs, li);
      this.renderItemTotalPrice(costs, li);
      sum += li.quantity;
      $('.cart-item-count').html(sum);
    });

    renderAlignShipmentNum();
    this.updateSummaryGeneral(order);

  };

  this.renderItemTotalPrice = function (cost, li) {
    $(".js-lineitem-total-" + li.id ).html("<span>" + li.quantity + "x$" + li.price + "</span>" + cost);
  }

  this.updateSummaryGeneral = function (order) {
    $('.js-order-total').html(order.display_total);
    $('.js-product-total').html(order.display_item_total)
    $("#shopping_cart_counter").html(order.total_quantity)

  }

  this.removeItemFromPopup = function(e){
    e.preventDefault();

    const lineItemId = $(this).data('line-item-id');
    that.updateItem($('.js-line-item-delete-btn-'+lineItemId), 'sub', 0);

  }
  this.updatePopup = function(order){
    $('.js-popup-cart-total').html(order.display_item_total)
  }
  this.registerEvent = function(eventName, cb) {
    const allEvents = $._data( $("body")[0], "events");

    if(!allEvents) {
      $('body').on('click', eventName, cb);
      return;
    }

    const allSelectors = allEvents.click.map(ev => ev.selector);
    if(!allSelectors.includes(eventName)){
      $('body').on('click', eventName, cb);
    }
  }
  this.registerEvent('.popup-cart-delete', this.removeItemFromPopup );
}



$(document).on('turbolinks:load', function() {
  let mainLayoutDiv       = $('.main-layout-section')
  let currentOrderNumber  = mainLayoutDiv.data('current-order-number')
  let currentOrderToken   = mainLayoutDiv.data('current-order-token')
  if(currentOrderNumber && currentOrderToken) {
    cartForm(currentOrderNumber, currentOrderToken );
  }

});


