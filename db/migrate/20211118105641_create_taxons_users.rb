class CreateTaxonsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_taxons_users do |t|
      t.references :user_id, index: true
      t.references :taxon_id, index: true
    end
  end
end
