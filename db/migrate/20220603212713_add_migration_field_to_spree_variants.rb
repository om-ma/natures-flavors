class AddMigrationFieldToSpreeVariants < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_variants, :old_product_id, :integer
  end
end
