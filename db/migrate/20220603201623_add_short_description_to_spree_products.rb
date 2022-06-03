class AddShortDescriptionToSpreeProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :short_description, :text
  end
end
