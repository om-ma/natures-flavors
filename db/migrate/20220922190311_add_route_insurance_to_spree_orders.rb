class AddRouteInsuranceToSpreeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :route_insurance_selected, :boolean, default:false
    add_column :spree_orders, :route_insurance_currency, :string, default: "USD"
    add_column :spree_orders, :route_insurance_price, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
