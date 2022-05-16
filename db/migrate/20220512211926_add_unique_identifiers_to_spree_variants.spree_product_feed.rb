# This migration comes from spree_product_feed (originally 20200427082007)
class AddUniqueIdentifiersToSpreeVariants < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_variants, :unique_identifier, :string
    add_column :spree_variants, :unique_identifier_type, :string, default: 'gtin'
  end
end
