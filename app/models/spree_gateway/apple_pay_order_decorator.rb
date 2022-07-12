# Override from spree_gateway to disable confirm page
module SpreeGateway
  module ApplePayOrderDecorator

    def confirmation_required?
      return false
    end

  end
end

::Spree::Order.prepend(::SpreeGateway::ApplePayOrderDecorator)
