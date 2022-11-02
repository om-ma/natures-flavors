class AddRouteInsuranceQuoteIdToSpreeOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :route_insurance_quote_id, :string, default: ""
  end
end
