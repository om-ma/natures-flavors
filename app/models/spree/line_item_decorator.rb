Spree::LineItem.class_eval do
    
  def destroy_inventory_units
    ActiveRecord::Base.connected_to(role: :writing) do
      throw(:abort) unless inventory_units.destroy_all
    end
  end

end
