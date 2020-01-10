# frozen_string_literal: true

require 'rack/auth/abstract/request'

module OauthBwergemn
  class Oauth2 < Grape::Middleware::Base
    attr_reader :auth_strategy

    def context
      env['api.endpoint']
    end

    def the_request=(env)
      @_the_request = ActionDispatch::Request.new(env)
    end

    def request
      @_the_request
    end

    def token
      token = if request.headers['Authorization'].present?
        if request.headers['Authorization'].include?('bearer')
          request.headers['Authorization'].try('split', 'bearer').try(:last).try(:strip)
        elsif request.headers['Authorization'].include?('Bearer')
          request.headers['Authorization'].try('split', 'Bearer').try(:last).try(:strip)
        else
          request.headers['Authorization']
        end
      else
        request.parameters['access_token']
      end
      token
    end

    ############
    # Authorization control.
    ############

    def endpoint_protected?
      auth_strategy.endpoint_protected?
    end

    def optional_endpoint?
      auth_strategy.optional_endpoint?
    end

    def args
      results = {}
      auth_strategy.auth_scopes.map { |s| (results = results.merge(s)) if s.is_a?(Hash) }
      results
    end

    def scopes
      results = []
      auth_strategy.auth_scopes.map { |s| (results << s) unless s.is_a?(Hash) }
      results
    end

    def authorize!
      access = Doorkeeper::AccessToken.find_by(token: token)
      unless access.present?
        raise OauthBwergemn::Errors::InvalidToken
      end
      resource = begin
                   # rubocop:disable Security/Eval
                   eval(OauthBwergemn.resources[args[:as].to_sym]).find_by(id: access.resource_owner_id)
                 # rubocop:enable Security/Eval
                 rescue
                   nil
                 end
      {
        resource_owner:      resource,
        resource_credential: {
          access_token:  access.token,
          scopes:        scopes,
          token_type:    'bearer',
          expires_in:    access.expires_in,
          refresh_token: access.refresh_token,
          created_at:    access.created_at.to_i
        }
      }
    end

    ############
    # Grape middleware methods
    ############

    def before
      set_auth_strategy(OauthBwergemn.auth_strategy)
      auth_strategy.api_context = context
      context.extend(OauthBwergemn::AuthMethods)

      context.protected_endpoint = endpoint_protected?
      context.optional_endpoint  = optional_endpoint?

      return unless context.protected_endpoint? || context.optional_endpoint?

      self.the_request = env

      if token.present? && (context.protected_endpoint? || context.optional_endpoint?)
        response                     = authorize!
        context.resource_token       = token
        context.resource_owner       = begin
                                         response[:resource_owner]
                                       rescue
                                         nil
                                       end
        context.resource_credentials = begin
                                         response[:resource_credentials]
                                       rescue
                                         nil
                                       end
      elsif token.nil? && context.protected_endpoint?
        raise OauthBwergemn::Errors::InvalidToken
      end
    end

    private

    def set_auth_strategy(strategy)
      @auth_strategy = OauthBwergemn::AuthStrategies.const_get(strategy.to_s.capitalize.to_s).new
    end
  end
end
