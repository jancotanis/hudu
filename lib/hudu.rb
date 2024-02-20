require "wrapi"
require File.expand_path('hudu/configuration', __dir__)
require File.expand_path('hudu/client', __dir__)

module Hudu
  extend Configuration
  extend WrAPI::RespondTo

  #
  # @return [Hudu::Client]
  def self.client(options = {})
    Hudu::Client.new(options)
  end

  def self.reset
    super

  end
end
