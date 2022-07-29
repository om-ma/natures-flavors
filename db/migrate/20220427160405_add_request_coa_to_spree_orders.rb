class AddRequestCoaToSpreeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :request_coa, :boolean, default:false
  end
end
