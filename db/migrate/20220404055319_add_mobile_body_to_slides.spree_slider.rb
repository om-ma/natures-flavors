# This migration comes from spree_slider (originally 20210610163228)
class AddMobileBodyToSlides < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_slides, :mobile_body, :string
  end
end
