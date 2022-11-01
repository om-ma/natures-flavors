class AddRouteInsuranceQuotePremiumToSpreeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :route_insurance_quote_premium, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
