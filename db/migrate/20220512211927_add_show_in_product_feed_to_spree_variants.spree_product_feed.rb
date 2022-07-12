# This migration comes from spree_product_feed (originally 20200518100354)
class AddShowInProductFeedToSpreeVariants < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_variants, :show_in_product_feed, :boolean, default: true
  end
end
