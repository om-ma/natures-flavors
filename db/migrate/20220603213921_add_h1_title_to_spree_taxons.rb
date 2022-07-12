class AddH1TitleToSpreeTaxons < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_taxons, :h1_title, :string
  end
end
