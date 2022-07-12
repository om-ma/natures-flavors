# This migration comes from spree_product_feed (originally 20200522211715)
class RenameColumnProductFeedActiveToFeedActive < ActiveRecord::Migration[6.0]
  def change
    rename_column :spree_products, :product_feed_active, :feed_active
  end
end
