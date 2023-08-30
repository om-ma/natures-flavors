class AddSoldCountToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :total_units_sold, :integer, default: 0
  end
end
