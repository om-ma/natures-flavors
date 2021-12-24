class AddIsDefaultToSpreeAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_addresses, :is_default, :boolean, default: false
  end
end
