class AddPopularityFiedToProduct < ActiveRecord::Migration[6.1]
  def change
  	add_column :spree_products, :popularity, :integer, default: 0
  end
end
