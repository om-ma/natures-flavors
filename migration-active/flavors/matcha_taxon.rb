Spree::Product.where(id: 9379).first.taxons << Spree::Taxon.where(name: 'Flavors').first << Spree::Taxon.where(name: 'Matcha').first;