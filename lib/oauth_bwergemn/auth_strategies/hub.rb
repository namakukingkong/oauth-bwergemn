# frozen_string_literal: true

module OauthBwergemn
  module AuthStrategies
    class Hub < OauthBwergemn::BaseStrategy
      def optional_endpoint?
        has_authorizations? && !!optional_oauth2
      end

      def endpoint_protected?
        has_authorizations? && !!authorization_type_oauth2
      end

      def has_auth_scopes?
        endpoint_protected? && !authorization_type_oauth2.empty?
      end

      def auth_scopes
        if optional_endpoint?
          optional_oauth2.map { |s| s.is_a?(String) || s.is_a?(Symbol) ? s.to_sym : s }
        else
          authorization_type_oauth2.map { |s| s.is_a?(String) || s.is_a?(Symbol) ? s.to_sym : s }
        end
      end

      private

      def has_authorizations?
        !!endpoint_authorizations
      end

      def endpoint_authorizations
        api_context.options[:route_options][:auth][:scopes]
      end

      def authorization_type_oauth2
        endpoint_authorizations
      end

      def optional_oauth2
        endpoint_authorizations
      end
    end
  end
end
