# This migration comes from spree (originally 20130326175857)
class AddStockLocationToRMA < ActiveRecord::Migration[4.2]
  def change
    # add_column :spree_return_authorizations, :stock_location_id, :integer
    # add_index :spree_return_authorizations, :stock_location_id
  end
end
