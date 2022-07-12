# This migration comes from spree_product_feed (originally 20200423203958)
class AddFeedItemsToSpreeProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_products, :unique_identifier, :string
    add_column :spree_products, :unique_identifier_type, :string, default: 'gtin'
    add_column :spree_products, :product_feed_active, :boolean, default: false
  end
end
