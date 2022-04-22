class AddNoindexToSpreeTaxon < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_taxons, :noindex, :boolean, default:false
  end
end
