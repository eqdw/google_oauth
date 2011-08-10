require 'google_oauth/hash_response'
require 'google_oauth/array_response'
require 'google_oauth/contacts'
require 'google_oauth/calendar'

module GoogleOAuth
  class Client

    def initialize(options = {})
      @application_id = options[:client_id]
      @application_secret = options[:client_secret]
      @callback = options[:redirect]
      @token = options[:token]
    end

    def authorize_url(options = {})
      options[:scope] ||= 'https://www.google.com/m8/feeds/'
      consumer.authorize_url(
        :redirect_uri => options[:callback] || @callback,
        :scope => options[:scope],
        :response_type => "code",
        :client_id => @application_id
        )
    end

    def authorize(options = {})
      @access_token ||= consumer.get_token({
          :code          => options[:code],
          :redirect_uri  => options[:callback]      || @callback,
          :client_id     => options[:client_id]     || @application_id,
          :client_secret => options[:client_secret] || @application_secret,
          :grant_type    => "authorization_code"
        })
      @token = @access_token.token
      @access_token
    end

    private
      def consumer
        @consumer ||= OAuth2::Client.new(
          @application_id,
          @application_secret,
          {
            :site => "https://accounts.google.com",
            :authorize_url => '/o/oauth2/auth',
            :token_url => '/o/oauth2/token'
          }
        )
      end

      def access_token
        OAuth2::AccessToken.new(consumer, @token)
      end

      def _get_jsonc(url, params={})
        params.merge! 'alt' => 'jsonc'
        res = _get(url, params)
        GoogleOAuth::HashResponse.new(JSON.parse(res)) rescue res
      end

      def _get_json(url, params={})
        params.merge! 'alt' => 'json'
        res = _get(url, params)
        JSON.parse(res) rescue res
      end

      def _get(url, params={})
        oauth_response = access_token.get(url, { :params => params })
      end

      def _post(url, params={}, headers={})
        oauth_response = access_token.post(url,{ :params => params, :headers => headers})
        JSON.parse(oauth_response) rescue oauth_response
      end

      def _delete(url)
        oauth_response = access_token.delete(url)
        JSON.parse(oauth_response) rescue oauth_response
      end
  end
end

