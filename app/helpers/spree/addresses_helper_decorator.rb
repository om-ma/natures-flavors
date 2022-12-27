module Spree
  module AddressesHelper

    def address_field(form, method, address_id = 'b', &handler)
      content_tag :div, id: [address_id, method].join, class: 'form-group form-floating mb-20' do
        if handler
          yield
        else
          is_required = Spree::Address.required_fields.include?(method)
          method_name = I18n.t("activerecord.attributes.spree/address.#{method}")
          required = Spree.t(:required)
          form.text_field(method,
                          class: ['form-control'].compact,
                          required: is_required,
                          placeholder: is_required ? "#{method_name} #{required}" : method_name,
                          aria: { label: method_name }) +
            form.label(method_name,
                       is_required ? "#{method_name} #{required}" : method_name,
                       class: 'text-uppercase')
        end
      end
    end

    def address_zipcode(form, country, address_id = 'b')
      country ||= address_default_country
      is_required = country.zipcode_required?
      method_name = Spree.t(:zipcode)
      required = Spree.t(:required)
      form.text_field(:zipcode,
                      class: ['form-control js-address-fields'].compact,
                      required: is_required,
                      placeholder: is_required ? "#{method_name} #{required}" : method_name,
                      aria: { label: Spree.t(:zipcode) }) +
        form.label(:zipcode,
                   is_required ? "#{method_name} #{required}" : method_name,
                   class: 'text-uppercase',
                   id: address_id + '_zipcode_label')
    end

    def address_state(form, country, address_id = 'b')
      country ||= address_default_country
      have_states = country.states.any?
      state_elements = [
        form.collection_select( :state_id, checkout_zone_applicable_states_for(country).sort_by(&:name),
                              :id, :name,
                               { prompt: Spree.t(:state) },
                               class: ['custom-select'].compact,
                               aria: { label: Spree.t(:state) },
                               disabled: !have_states) 
      ].join.tr('"', "'").delete("\n") + form.label(Spree.t(:state))

      
      state_elements.html_safe
    end

    def user_available_addresses
      @user_available_addresses ||= begin
        return [] unless try_spree_current_user

        states = current_store.countries_available_for_checkout.each_with_object([]) do |country, memo|
          memo << current_store.states_available_for_checkout(country)
        end.flatten

        try_spree_current_user.addresses.sort_by{ |a| a.id }
      end
    end

    def select_user_available_addresses(order_ship_address_id)
      return nil if user_available_addresses.empty?

      if order_ship_address_id.nil?
        user_available_addresses.each do |address|
          return address.id if address.is_default
        end
        return user_available_addresses.first.id
      else
        user_available_addresses.each do |address|
          return address.id if address.id == order_ship_address_id
        end
        return user_available_addresses.first.id
      end
    end
  end

end
