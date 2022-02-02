class AddCheckNumberToSpreePayments < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_payments, :check_no, :string
  end
end
