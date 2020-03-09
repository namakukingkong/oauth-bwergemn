# frozen_string_literal: true

require 'oauth_bwergemn/version'

require 'grape'

require 'oauth_bwergemn/configuration'

require 'oauth_bwergemn/oauth2'
require 'oauth_bwergemn/extension'
require 'oauth_bwergemn/helpers'

require 'oauth_bwergemn/base_strategy'
require 'oauth_bwergemn/auth_strategies/hub'
require 'oauth_bwergemn/auth_methods/auth_methods'

require 'oauth_bwergemn/errors/invalid_token'
require 'oauth_bwergemn/errors/invalid_scope'

module OauthBwergemn
  extend OauthBwergemn::Configuration
  define_setting :auth_strategy, 'hub'
  define_setting :resources, user: 'User'
  define_setting :default_resources, :user

  def self.config_resources
    resources
  end
end
