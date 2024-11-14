# frozen_string_literal: true

module Hudu
  # Generic error to be able to rescue all Hudu errors
  class HuduError < StandardError; end

  # Error when authentication fails
  class AuthenticationError < HuduError; end
end
