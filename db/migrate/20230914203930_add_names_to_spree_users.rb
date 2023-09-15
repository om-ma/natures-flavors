class AddNamesToSpreeUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_users, :first_name, :string, default: '', null: false
    add_column :spree_users, :last_name, :string, default: '', null: false

    add_index :spree_users, [:first_name], name: 'index_users_on_first_name'
    add_index :spree_users, [:last_name],  name: 'index_users_on_last_name'
  end
end
