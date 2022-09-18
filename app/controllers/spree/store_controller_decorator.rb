Spree::StoreController.class_eval do

  # Override to manually switch to writing db connection in context of readonly action
  def api_tokens
    ActiveRecord::Base.connected_to(role: :writing) do
      render json: {
        order_token: simple_current_order&.token,
        oauth_token: current_oauth_token&.token
      }
    end
  end

end
