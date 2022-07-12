class AddMigrationFieldToSpreeTaxons < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_taxons, :old_category_id, :integer
    add_column :spree_taxons, :old_category_url, :string
  end
end
