/* Route */
function RouteShippingProtectionManager (input1) {
  this.input = input1
  this.orderTotal = this.input.orderTotal
  this.routeInsuranceContainer = this.input.routeInsuranceContainer
  this.routeInsuranceTotal = this.input.routeInsuranceTotal
  this.orderRouteInsuranceSelected = this.input.orderRouteInsuranceSelected
  this.orderRouteInsurancePrice = this.input.orderRouteInsurancePrice
  this.formatOptions = {
    symbol: this.routeInsuranceTotal.data('currency'),
    decimal: this.routeInsuranceTotal.attr('decimal-mark'),
    thousand: this.routeInsuranceTotal.attr('thousands-separator'),
    precision: this.routeInsuranceTotal.attr('precision')
  }
}

RouteShippingProtectionManager.prototype.parseCurrencyToFloat = function (input) {
  return accounting.unformat(input, this.formatOptions.decimal)
}

RouteShippingProtectionManager.prototype.totalInsuranceAmount = function (newInsuranceTotal, oldInsuranceTotal) {
  return newInsuranceTotal - oldInsuranceTotal
}

RouteShippingProtectionManager.prototype.readjustSummarySection = function (insuranceSelected, orderTotal, newInsuranceTotal, oldInsuranceTotal) {
  this.routeInsuranceTotal.html(accounting.formatMoney(accounting.toFixed(newInsuranceTotal, 10), this.formatOptions));
  if (insuranceSelected) {
    this.routeInsuranceContainer.removeClass('route-insurance-hide')
  } else {
    this.routeInsuranceContainer.addClass('route-insurance-hide')
  }

  var newOrderTotal = orderTotal + this.totalInsuranceAmount(newInsuranceTotal, oldInsuranceTotal)
  return this.orderTotal.html(accounting.formatMoney(accounting.toFixed(newOrderTotal, 10), this.formatOptions))
}

RouteShippingProtectionManager.prototype.bindEvent = function () {
  routeapp.on_insured_change(function(insurance_details){
    if (insurance_details.insurance_selected) {
      this.orderRouteInsuranceSelected.val(true)
      this.orderRouteInsurancePrice.val(insurance_details.insurance_price)
    }
    else {
      this.orderRouteInsuranceSelected.val(false)
      this.orderRouteInsurancePrice.val('0.0')
    }
    return this.readjustSummarySection(
      insurance_details.insurance_selected,
      this.parseCurrencyToFloat(this.orderTotal.html()),
      this.orderRouteInsurancePrice.val(),
      this.parseCurrencyToFloat(this.routeInsuranceTotal.html())
    )
  }.bind(this))
}

Spree.ready(function ($) {
  var input = {
    orderTotal: $('#summary-order-total'),
    routeInsuranceContainer: $('.route-insurance-container'),
    routeInsuranceTotal: $('[data-hook="route-insurance-total"]'),
    orderRouteInsuranceSelected: $('#order_route_insurance_selected'),
    orderRouteInsurancePrice: $('#order_route_insurance_price')
  }
  return new RouteShippingProtectionManager(input).bindEvent()
})