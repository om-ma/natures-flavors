# Google Sheet
#
# Create Customer and Address
# =CONCATENATE("user = Spree::User.create(email: '",E2,"', password: SecureRandom.hex(13)); country = Spree::Country.where(name: '",X2,"').first; address = user.addresses.build(firstname: '",C2,"', lastname: '",D2,"', address1: '",P2,"', address2: '",Q2,"', city: '",S2,"', zipcode: '",R2,"', phone: '",T2,"', state_name: '",Y2,"', country: country); address.save(); user.ship_address_id = address.id; user.bill_address_id = address.id; user.save();")
