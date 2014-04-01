module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper

      option :client_options, {
        :site => "http://localhost:3000",
        :authorize_path => "/oauth/authorize"
      }

      uid do
        raw_info["_id"]
      end

      info do
        {
          :email => raw_info["email"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end

      def authorize_params
        super.tap do |params|
          %w[state].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end

          #params[:scope] ||= DEFAULT_SCOPE
        end
      end
      
    end
  end
end