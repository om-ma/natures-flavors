Spree::Admin::BaseController.class_eval do
  include Spree::CacheHelper
  
  def admin_oauth_token
    user = try_spree_current_user
    return unless user

    ActiveRecord::Base.connected_to(role: :writing) do
      @admin_oauth_token ||= begin
        Doorkeeper::AccessToken.active_for(user).where(application_id: admin_oauth_application.id).last ||
          Doorkeeper::AccessToken.create!(
            resource_owner_id: user.id,
            application_id: admin_oauth_application.id,
            scopes: admin_oauth_application.scopes
          )
      end.token
    end
  end

end
