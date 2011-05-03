require 'google_oauth/contacts'
require 'google_oauth/calendar'

module GoogleOAuth
  class Client
    
    def initialize(options = {})
      @application_id = options[:application_id]
      @application_secret = options[:application_secret]
      @callback = options[:callback]
      @token = options[:token]
    end
  
    def authorize_url(options = {})
      options[:scope] ||= 'https://www.google.com/m8/feeds/'
      consumer.web_server.authorize_url(
        :redirect_uri => options[:callback] || @callback,
        :scope => options[:scope]
      )
    end
    
    def authorize(options = {})
      @access_token ||= consumer.web_server.get_access_token(
        options[:code],
        :redirect_uri => options[:callback] || @callback
      )
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
            :access_token_url => '/o/oauth2/token'
          }
        )
      end

      def access_token
        OAuth2::AccessToken.new(consumer, @token)
      end
      
      def _get(url, params={})
        oauth_response = access_token.get(url, params)
        JSON.parse(oauth_response) rescue oauth_response
      end

      def _post(url, params={}, headers={})
        oauth_response = access_token.post(url, params, headers)
        puts oauth_response.inspect
        JSON.parse(oauth_response) rescue oauth_response
      end

      def _delete(url)
        oauth_response = access_token.delete(url)
        JSON.parse(oauth_response) rescue oauth_response
      end
  end
end
   
