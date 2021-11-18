class CreateTaxonsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_taxons_users do |t|
    	t.bigint :user_id
    	t.bigint :taxon_id
    end
  end
end
