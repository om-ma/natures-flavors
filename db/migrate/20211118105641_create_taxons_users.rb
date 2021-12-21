class CreateTaxonsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_taxons_users do |t|
      t.references :user, index: true
      t.references :taxon, index: true
    end
  end
end