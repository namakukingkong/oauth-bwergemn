OauthBwergemn.setup do |config|
  # your authentication server
  config.auth_strategy     = "hub"
  config.is_custom_scopes  = false
  config.resources         = { user: "Models::Auth" } # { admin: "Models::Admin", user: "Models::User" , moderator: "Models::Moderator" }
  config.default_resources = :user
end
