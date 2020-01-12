# frozen_string_literal: true

module OauthBwergemn
  module Extension
    def oauth2(*scopes)
      scopes = Doorkeeper.configuration.default_scopes.all if scopes.all? { |x| x.nil? }
      if respond_to?(:route_setting) # >= grape-0.10.0
        description = route_setting(:description) || route_setting(:description, {})
      else
        description = @last_description ||= {}
      end
      # case WineBouncer.configuration.auth_strategy
      # when :default
      description[:auth] = { scopes: scopes }
      # when :swagger
      description[:authorizations] = { oauth2: scopes.map { |x| { scope: x } } }
      # end
    end

    # Grape::API::Instance is defined in grape 1.2.0 or above
    grape_api = defined?(Grape::API::Instance) ? Grape::API::Instance : Grape::API
    grape_api.extend self
  end
end
