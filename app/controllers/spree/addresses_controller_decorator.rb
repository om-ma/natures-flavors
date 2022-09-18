Spree::AddressesController.class_eval do

  # Override load_and_authorize_resource in default Spree class
  skip_authorize_resource :only => [ :create, :edit, :new, :update, :destroy, :set_as_default ]
  
  def create

    @address = try_spree_current_user.addresses.build(address_params)

    ActiveRecord::Base.transaction do

      if @address.is_default
        user_addresses            = spree_current_user.addresses

        if user_addresses.present?
          user_addresses.update_all(is_default: false)
        end
          
      end
      if create_service.call(user: try_spree_current_user, address_params: @address.attributes).success?
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
  end

  def update
    if update_service.call(address: @address, address_params: address_params).success?
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

  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr? }
      format.js
    end
  end

  def set_as_default
    user_addresses            = spree_current_user.addresses
    current_user_address      = user_addresses.find_by(id: params[:id])

    ActiveRecord::Base.connected_to(role: :writing) do
      ActiveRecord::Base.transaction do
        if current_user_address.present?
          user_addresses.update_all(is_default: false)
          current_user_address.update(is_default: true)
          spree_current_user.update(ship_address: current_user_address, bill_address: current_user_address)
        end
      end
    end
  end

  private
  def address_params
    params[:address].permit(:address,
                            :firstname,
                            :lastname,
                            :company,
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