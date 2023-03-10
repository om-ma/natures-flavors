class AddTopLevelCategoryDescriptionToSpreeTaxons < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_taxons, :top_level_category_description, :text
  end
end
