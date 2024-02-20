require File.expand_path('error', __dir__)

module Hudu
  # Deals with authentication flow and stores it within global configuration
  module Authentication

    # 
    # Authorize to the Hudu portal and return access_token
    def login(options = {})
      raise ArgumentError, "Accesstoken/api-key not set" unless api_key
      connection_options.merge!({ headers: { "x-api-key": api_key }})
      # only api key needed 
      # will do sanitty check if token if valid
      get('/api/v1/api_info')
    rescue Faraday::Error => e
      raise AuthenticationError, e
    end

  end
end
