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
      if request.headers['Authorization'].present?
        if request.headers['Authorization'].include?('bearer')
          token = request.headers['Authorization'].try('split', 'bearer').try(:last).try(:strip)
        elsif request.headers['Authorization'].include?('Bearer')
          token = request.headers['Authorization'].try('split', 'Bearer').try(:last).try(:strip)
        else
          token = request.headers['Authorization']
        end
      else
        token = request.parameters['access_token']
      end
      token
    end

    ############
    # Authorization control.
    ############
    def endpoint_protected?
      auth_strategy.endpoint_protected?
    end

    def args
      results = {}
      auth_strategy.auth_scopes.map { |s| (results = results.merge(s)) if s.is_a?(Hash) }
      results
    end

    def scopes
      results = []
      auth_strategy.auth_scopes.map { |s| (results << s) unless s.is_a?(Hash) }
      results.map! &:to_sym
    end

    def access_scopes access
      if OauthBwergemn.is_custom_scopes
        access.scopes.map!(&:to_sym) rescue []
      else
        access.scopes.all.map!(&:to_sym) rescue []
      end
    end

    def is_args_include_validate?
      if args.key?(:validate) && ![true, false].include?(args[:validate])
        raise OauthBwergemn::Errors::InvalidScope.new("Not valid scope '#{args[:validate]}' in `oauth2 scope`")
      end
      args.key?(:validate)
    end

    def is_args_include_as?
      args.key?(:as)
    end

    def scope_authorize! access
      if scopes.present? && access
        unless (scopes & (access_scopes access)).present?
          raise OauthBwergemn::Errors::InvalidScope.new('OAuth Scope is disallowed')
        end
      end
    end

    def token_optional?
      is_args_include_validate? && [true, false].include?(args[:validate]) && args[:validate].eql?(false)
    end

    def token_required?
      is_args_include_validate? && [true, false].include?(args[:validate]) && args[:validate].eql?(true) || is_args_include_validate?.blank?
    end

    def authorize!
      access = Doorkeeper::AccessToken.find_by(token: token)
      unless access.present?
        raise OauthBwergemn::Errors::InvalidToken
      end
      resource_as = (is_args_include_as? ? args[:as] : OauthBwergemn.default_resources)
      # rubocop:disable Security/Eval
      resource = eval(OauthBwergemn.resources[resource_as.to_sym]).where(id: access.resource_owner_id).last rescue nil
      # rubocop:enable Security/Eval
      if OauthBwergemn.is_custom_scopes
        scope_authorize! resource
      else
        scope_authorize! access
      end
      {
        resource_owner:      resource,
        resource_credential: {
          access_token:  access.token,
          scopes:        (access_scopes access),
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

      return unless context.protected_endpoint?

      self.the_request = env
      if token_optional? && context.protected_endpoint?
        context.resource_token       = token
        context.resource_owner       = nil
        context.resource_credentials = nil
        response = authorize! rescue nil
        if response.present?
          context.resource_owner = response[:resource_owner] rescue nil
          context.resource_credentials = response[:resource_credentials] rescue nil
        end
      elsif token.present? && token_required? && context.protected_endpoint?
        response               = authorize!
        context.resource_token = token
        context.resource_owner = response[:resource_owner] rescue nil
        context.resource_credentials = response[:resource_credentials] rescue nil
      elsif context.resource_owner.nil? && context.protected_endpoint?
        raise OauthBwergemn::Errors::InvalidToken
      else
        raise OauthBwergemn::Errors::InvalidToken
      end
    end

    private

    def set_auth_strategy(strategy)
      @auth_strategy = OauthBwergemn::AuthStrategies.const_get(strategy.to_s.capitalize.to_s).new
    end
  end
end
