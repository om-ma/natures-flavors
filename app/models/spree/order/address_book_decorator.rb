Spree::Order::AddressBook.module_eval do

  private

  def update_or_create_address(attributes = {})
    return if attributes.blank?

    attributes.transform_values! { |v| v == '' ? nil : v }

    default_address_scope = user ? user.addresses : ::Spree::Address
    default_address = default_address_scope.find_by(id: attributes[:id])

    if default_address&.editable?
      default_address.update(attributes)

      return default_address
    end

    # Override: Add this to filter out deleted addresses.
    attributes[:deleted_at] = nil

    # Override: Add is_default to except list. Ignore is_default value.
    address = ::Spree::Address.find_or_create_by(attributes.except(:id, :updated_at, :created_at, :is_default))

    # Override: If is_default param is different than on address found, change is_default value.
    if address.is_default != attributes[:is_default]
      address.update({ is_default: attributes[:is_default] })
    end

    return address
  end

end