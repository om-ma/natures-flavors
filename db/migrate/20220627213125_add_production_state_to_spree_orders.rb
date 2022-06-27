class AddProductionStateToSpreeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :production_state, :string
  end
end
