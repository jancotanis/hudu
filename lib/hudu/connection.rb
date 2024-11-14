# frozen_string_literal: true

require File.expand_path('rate_throttle_middleware', __dir__)

module Hudu
  # Create connection including and keep it persistent so we add the rate throtling middleware only once
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
