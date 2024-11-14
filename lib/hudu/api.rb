# frozen_string_literal: true

require 'wrapi'
require File.expand_path('authentication', __dir__)
require File.expand_path('configuration', __dir__)
require File.expand_path('connection', __dir__)

module Hudu
  # @private
  class API
    # @private
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    # Creates a new API and copies settings from singleton
    def initialize(options = {})
      options = Hudu.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end
      conf
    end

    include Configuration
    include WrAPI::Connection
    include Connection
    include WrAPI::Request
    include WrAPI::Authentication
    include Authentication
  end
end
