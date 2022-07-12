class AddMigrationFieldToSpreeTaxonomies < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_taxonomies, :old_category_id, :integer
  end
end
