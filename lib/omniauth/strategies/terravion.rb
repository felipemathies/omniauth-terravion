require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Terravion < OmniAuth::Strategies::OAuth2
      option :name, :terravion

      option :client_options, {
      	site: "https://api2.terravion.com",
        authorize_url: 'https://maps.terravion.com/oauth2/authorize',
        token_url: 'https://maps.terravion.com/oauth2/token',
     	}

      option :access_token_options, {
        mode: :query,
        param_name: :access_token
      }

      uid{ raw_info['id'] }

      extra do
         {
           raw_info: raw_info
         }
      end

      def raw_info
        @raw_info ||= {}
        @raw_info["id"] = access_token.get('/users/getUserId').parsed
        @raw_info
      end

      def access_token_options
        options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      end

      protected

      def build_access_token
        super.tap do |token|
          token.options.merge!(access_token_options)
        end
      end
    end
  end
end