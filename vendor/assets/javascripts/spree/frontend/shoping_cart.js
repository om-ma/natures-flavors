
  $(document).on("click" , "#shopping_cart_bag", function(e){
    var cartBagElement  = $('.cart-nav')
    $.ajax({
    type: 'GET',
    url: '/refresh_cart_bag.js',
    }).done(function () {
    }).fail(function (response) {
    })
  e.preventDefault();
});

$(document).ready(function() {

  $(document).on("click" , ".close-sidebar-btn", function(e){
    $('.cart-sidebar').toggleClass("active");
    $('.overlay').toggleClass("active");
    $('body').toggleClass("hide-scroll");
  e.preventDefault();
  });

  $('.cart-sidebar-wrapper .overlay').on('click', function(e) {
    $('.nav-cart').toggleClass("active");
    $('.cart-sidebar').toggleClass("active");
    $('.cart-sidebar-wrapper .overlay').toggleClass("active");
    $('body').removeClass("hide-scroll");
    e.preventDefault();
  });
});

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
            $('.emptyCartPageSection').show();
            let emptyCartHtml = $('.emptyCartPageSection').html();
            $('.empty-cart-area').html();
            $('.cart-summary').html(emptyCartHtml)
            //window.location = '/cart'
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
        //that.updateVendorSummary(item, result);

        updateSummaryGeneral(result);
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
      if (parseInt(li.variant.vendor_id) === parseInt(vendorId)) {
        let cost = li.display_amount;
        let itemCount = li.quantity;
        renderQtyLabels(itemCount, li);
        renderItemTotalPrice(cost, li);
      }
      let cost = li.display_amount;
      this.renderItemTotalPrice(cost, li);
      sum += li.quantity;
      $('.cart-item-count').html(sum);
    });

    renderAlignShipmentNum();
    this.updateSummaryGeneral(order);

  };

  this.renderItemTotalPrice = function (cost, li) {
    $(".js-lineitem-total-" + li.id ).html(cost);
  }

  this.updateSummaryGeneral = function (order) {
    $('.js-order-total').html(order.display_total);
    $('.js-product-total').html(order.display_item_total)
  }

  this.addItem = function (e) {
    e.preventDefault();
    $qtyEl = $(this).siblings('.line_item_quantity').first();
    let currentCount = parseInt($qtyEl.val());
    let newCount = currentCount + 1;
    $qtyEl.val(newCount);
    that.updateItem(this, 'add', newCount);
  };

  this.subItem = function (e) {
    e.preventDefault();
    $qtyEl = $(this).siblings('.line_item_quantity').first();
    let currentCount = parseInt($qtyEl.val());
    let newCount = currentCount - 1;
    $qtyEl.val(newCount);
    that.updateItem(this, 'sub', newCount);
  };

  this.removeItemFromPopup = function(e){
    e.preventDefault();

    const lineItemId = $(this).data('line-item-id');
    that.updateItem($('.js-line-item-delete-btn-'+lineItemId), 'sub', 0);

  }
  this.updatePopup = function(order){
    $('.js-popup-cart-total').html(order.display_item_total)
  }
  $('body').on('click', '.popup-cart-delete', this.removeItemFromPopup);
  $('body').on('click', '.jsAddItem', this.addItem);
  $('body').on('click', '.jsSubItem', this.subItem);
}
