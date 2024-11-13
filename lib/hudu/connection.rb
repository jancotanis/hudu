require File.expand_path('rate_throttle_middleware', __dir__)

module Hudu
  # Create connection including authorization parameters with default Accept format and User-Agent
  # By default
  # - Bearer authorization is access_token is not nil override with @setup_authorization
  # - Headers setup for client-id and client-secret when client_id and client_secret are not nil @setup_headers
  # @private
  module Connection
    private

    def connection
      unless @connection
        @connection = super
        @connection.use RateThrottleMiddleware, limit: 250, period: 60
      end
      @connection
    end
  end
end
