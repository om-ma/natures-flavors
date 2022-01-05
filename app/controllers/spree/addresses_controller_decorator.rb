Spree::AddressesController.class_eval do


  def create
    @address = spree_current_user.addresses.build(address_params)

    if @address.is_default
      user_addresses            = spree_current_user.addresses

      if user_addresses.present?
        user_addresses.update_all(is_default: false)
      end
        
    end

    if @address.save
      # flash[:notice] = I18n.t(:successfully_created, scope: :address_book)
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

  def update
    if @address.editable?
      if @address.update(address_params)
        # flash[:notice] = I18n.t(:successfully_updated, scope: :address_book)
        respond_to do |format|
          format.html { redirect_back_or_default(account_path) }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :action => 'edit' }
          format.js
        end
      end
    else
      new_address = @address.clone
      new_address.attributes = address_params
      @address.update_attribute(:deleted_at, Time.now)
      if new_address.save
        # flash[:notice] = I18n.t(:successfully_updated, scope: :address_book)
        respond_to do |format|
          format.html { redirect_back_or_default(account_path) }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :action => 'edit' }
          format.js
        end
      end
    end
  end

  def destroy
    @address.destroy
    # flash[:notice] = I18n.t(:successfully_removed, scope: :address_book)
    respond_to do |format|
      format.html { redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr? }
      format.js
    end
  end

  def new_checkout_address
    @order = current_order
    @address_type = params[:address_type]
  end

  def set_as_default
    user_addresses            = spree_current_user.addresses
    current_user_address      = user_addresses.find_by(id: params[:id])

    ActiveRecord::Base.transaction do
      if current_user_address.present?
        user_addresses.update_all(is_default: false)
        current_user_address.update(is_default: true)
        spree_current_user.update(ship_address: current_user_address, bill_address: current_user_address)
      end
    end
  end

  private
  def address_params
    params[:address].permit(:address,
                            :firstname,
                            :lastname,
                            :address1,
                            :address2,
                            :city,
                            :state_id,
                            :zipcode,
                            :country_id,
                            :phone,
                            :is_default
    )
  end

end