# frozen_string_literal: true

module OauthBwergemn
  module AuthMethods
    attr_accessor :the_access_token, :current_user, :credentials
    attr_accessor :resource__token, :resource_owner, :resource_credentials

    def protected_endpoint=(protected)
      @protected_endpoint = protected
    end

    def protected_endpoint?
      @protected_endpoint || false
    end

    def optional_endpoint=(opt)
      @optional_endpoint = opt
    end

    def optional_endpoint?
      @optional_endpoint || false
    end

    # rubocop:disable Lint/DuplicateMethods
    def resource_token
      @_resource_token
    end

    def resource_token=(token)
      @_resource_token = token
    end

    def resource_owner=(resource)
      @_resource_owner = resource
    end

    def resource_owner
      @_resource_owner
    end

    def resource_credentials=(credentials)
      @_resource_credentials = credentials
    end

    def resource_credentials
      @_resource_credentials
    end
    # rubocop:enable Lint/DuplicateMethods
  end
end
