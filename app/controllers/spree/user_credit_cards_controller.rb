class Spree::UserCreditCardsController < Spree::StoreController
  before_action :load_user_ccs
  before_action :load_cc
  before_action :load_new_cc_object, only: [:new, :create]
  
  def new
  end
  
  def create
    @user_cc                = current_spree_user.credit_cards.build(new_cc_params)
    @user_cc.payment_method = @default_payment_method
    
    if @user_cc.save
      respond_to do |format|
        format.html { redirect_to account_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.js
      end
    end
  end
  
  def destroy
    checkout_cc_current_payments        = @cc.payments.checkout
    current_order_checkout_payment_ids  = current_order.payments.checkout.pluck(:id)
    cc_payments_in_current_order        = checkout_cc_current_payments.where(id: current_order_checkout_payment_ids )
    
    ActiveRecord::Base.transaction do
      if @cc.destroy
        cc_payments_in_current_order.destroy_all if cc_payments_in_current_order.present?
      end
    end
    
    redirect_to(request.env['HTTP_REFERER'] || checkout_state_path('payment')) unless request.xhr?
    
  end

  def set_as_default
    if @cc.present?
      ActiveRecord::Base.transaction do
        @user_ccs.update_all(default: false)
        @cc.update(default: true)
      end  
    end
  end

  private

  def new_cc_params
    params.require(:payment_source).permit(:name, :number, :expiry, :verification_value, :cc_type, :default)
  end
  
  def load_user_ccs
    @user_ccs = current_spree_user.credit_cards
  end

  def load_cc
    @cc = @user_ccs.find_by(id: params[:id])
  end
  
  def load_new_cc_object
    @default_payment_method = Spree::PaymentMethod.find_by_type('Spree::Gateway::AuthorizeNetCim')
    @new_cc = Spree::CreditCard.new(payment_method: @default_payment_method)
  end
  
end
