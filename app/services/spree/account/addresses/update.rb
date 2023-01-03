module Spree
  module Account
    module Addresses
      class Update
        prepend Spree::ServiceModule::Base
        include Spree::Account::Addresses::Helper

        attr_accessor :country

        def call(address:, address_params:)
          address_params[:country_id] ||= address.country_id
          fill_country_and_state_ids(address_params)

          if address&.editable?
            address.update(address_params) ? success(address) : failure(address)
          else
            # Override. Do not delete existing address. Clone it. Then delete old address attacheded to order(s).
            new_address = address.clone
            new_address.attributes = address_params
            new_address.user_id = address.user_id
            if new_address.save
              address.update_attribute(:deleted_at, Time.current)
              success(new_address)
            else
              failure(address)
            end
          end
        end

        private

        def new_address(address_params = {})
          @new_address ||= ::Spree::Address.find_or_create_by(address_params.except(:id, :updated_at, :created_at))
        end
      end
    end
  end
end
