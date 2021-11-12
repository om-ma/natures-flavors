# This migration comes from spree_api (originally 20210727102516)
  def change
    change_column :spree_oauth_access_grants, :resource_owner_id, :bigint
    change_column :spree_oauth_access_grants, :application_id, :bigint

    change_column :spree_oauth_access_tokens, :resource_owner_id, :bigint
    change_column :spree_oauth_access_tokens, :application_id, :bigint
  end
end
