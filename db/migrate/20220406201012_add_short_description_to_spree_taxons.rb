class AddShortDescriptionToSpreeTaxons < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_taxons, :short_description, :text
  end
end
