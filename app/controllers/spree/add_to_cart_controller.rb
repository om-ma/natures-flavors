module Spree
  class AddToCartController < Spree::StoreController
    def create
      variant = Spree::Product.find_by(id:params[:id]).master
      @order = current_order || Order.incomplete.find_by(token: cookies.signed[:token]) || current_order(create_order_if_necessary: true)
      line_item = Spree::Dependencies.cart_add_item_service.constantize.call(order: @order, variant: variant,quantity: 1, options: {}).value

      if line_item.save
        flash[:success] = "#{variant.name} successfully added to cart"
      else
        flash[:error] = line_item.errors.full_messages.join(",")
      end
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.js
      end
    end
  end
end
