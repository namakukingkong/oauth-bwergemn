# frozen_string_literal: true

module OauthBwergemn
  module AuthStrategies
    class Hub < OauthBwergemn::BaseStrategy
      def endpoint_protected?
        !!endpoint_authorizations
      end

      def has_auth_scopes?
        !!endpoint_authorizations &&
          endpoint_authorizations.key?(:scopes) &&
          !endpoint_authorizations[:scopes].empty?
      end

      def auth_scopes
        endpoint_authorizations[:scopes].map { |s| s.is_a?(String) || s.is_a?(Symbol) ? s.to_sym : s }
      end

      private

      def endpoint_authorizations
        api_context.options[:route_options][:auth]
      end
    end
  end
end
