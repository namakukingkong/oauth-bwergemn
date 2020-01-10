OauthBwergemn.setup do |config|
  # your authentication server
  config.auth_strategy = "hub"
  config.resources     = { admin: "Models::Admin", user: "Models::User" }
end