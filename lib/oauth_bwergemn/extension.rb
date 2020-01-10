# frozen_string_literal: true

module OauthBwergemn
  module Extension
    def oauth2(*scopes)
      description = if respond_to?(:route_setting) # >= grape-0.10.0
        route_setting(:description) || route_setting(:description, {})
      else
        @last_description ||= {}
      end

      description[:auth] = { scopes: scopes }
      description[:authorizations] = { oauth2: scopes.map { |x| { scope: x } } }
    end

    def optional_oauth2(*scopes)
      description = if respond_to?(:route_setting) # >= grape-0.10.0
        route_setting(:description) || route_setting(:description, {})
      else
        @last_description ||= {}
      end

      description[:authorizations] = { optional_oauth2: scopes.map { |x| { scope: x } } }
    end

    Grape::API.extend self
  end
end
