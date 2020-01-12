OauthBwergemn.setup do |config|
  # your authentication server
  config.auth_strategy = "hub"
  config.resources = { user: "Models::User" }  # { admin: "Models::Admin", user: "Models::User" , moderator: "Models::Moderator" }
end