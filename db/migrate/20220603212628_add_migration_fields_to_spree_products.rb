class AddMigrationFieldsToSpreeProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :old_product_id, :integer
    add_column :spree_products, :old_product_url, :string
  end
end
