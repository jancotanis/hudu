# frozen_string_literal: true

require 'wrapi'
require File.expand_path('version', __dir__)
require File.expand_path('pagination', __dir__)

module Hudu
  # Defines constants and methods related to configuration
  module Configuration
    include WrAPI::Configuration

    # An array of additional valid keys in the options hash when configuring a [Hudu::API]
    VALID_OPTIONS_KEYS = (WrAPI::Configuration::VALID_OPTIONS_KEYS + [:api_key]).freeze

    # @private
    attr_accessor(*VALID_OPTIONS_KEYS)

    DEFAULT_UA         = "Ruby Hudu API wrapper #{Hudu::VERSION}"
    DEFAULT_PAGINATION = RequestPagination::PagingInfoPager
    DEFAULT_PAGE_SIZE  = 25

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      super
      self.api_key          = nil
      self.endpoint         = nil
      self.user_agent       = DEFAULT_UA
      self.page_size        = DEFAULT_PAGE_SIZE
      self.pagination_class = DEFAULT_PAGINATION
    end
  end
end
