# frozen_string_literal: true

module OauthBwergemn
  module AuthMethods
    attr_accessor :resource_token, :resource_owner, :resource_credentials

    # rubocop:disable Lint/DuplicateMethods
    def protected_endpoint=(protected)
      @protected_endpoint = protected
    end

    def protected_endpoint?
      @protected_endpoint || false
    end

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
