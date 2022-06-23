# Google Sheet
#
# Create Customer and Address
=CONCATENATE("user = Spree::User.create(email: '",E2,"', password: SecureRandom.hex(13)); country = Spree::Country.where(name: '",X2,"').first; address = user.addresses.build(firstname: '",C2,"', lastname: '",D2,"', address1: '",P2,"', address2: '",Q2,"', city: '",S2,"', zipcode: '",R2,"', phone: '",T2,"', state_name: '",Y2,"', country: country); address.save(); user.ship_address_id = address.id; user.bill_address_id = address.id; user.save();")

# Update taxons
=CONCATENATE("UPDATE spree_taxons SET description='",SUBSTITUTE(G2,"'","''"),"', meta_title='",SUBSTITUTE(H2,"'","''"),"', meta_description='",SUBSTITUTE(J2,"'","''"),"', meta_keywords='",SUBSTITUTE(I2,"'","''"),"', old_category_url='",D2,"', h1_title='",SUBSTITUTE(E2,"'","''"),"', noindex=",K2, ", hide_from_nav=",L2, " WHERE old_category_id=",C2,";")

# Delete inactive taxons
=CONCATENATE("Spree::Taxon.where(old_category_id: ",C2,").delete_all;")

# Upload taxon images
=CONCATENATE("owner = Spree::Taxon.where(old_category_id: ",C2,").first; attachment_file = File.new('",F2,"', 'rb'); filename = '",O2,"'; Spree::TaxonImage.create!(attachment: { io: attachment_file, filename: filename }, viewable: owner);")

# Update product short descriptions
=CONCATENATE("UPDATE spree_products SET short_description='",SUBSTITUTE(E2,"'","''"), "' WHERE old_product_id=",D2,";")

# Update product properties
=CONCATENATE("UPDATE spree_product_properties SET value = '",,SUBSTITUTE(F2,"'","''"),"' WHERE product_id in (SELECT id FROM spree_products WHERE old_product_id = ",D2,");")
