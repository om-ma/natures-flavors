class AddAmountOldToSpreePrices < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_prices, :amount_old,  :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end
