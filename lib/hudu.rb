# frozen_string_literal: true

require 'wrapi'
require File.expand_path('hudu/configuration', __dir__)
require File.expand_path('hudu/client', __dir__)

# The Hudu module provides utilities to manage and manipulate assets within the Hudu api
module Hudu
  extend Configuration
  extend WrAPI::RespondTo

  #
  # @return [Hudu::Client]
  def self.client(options = {})
    Hudu::Client.new(options)
  end
end
