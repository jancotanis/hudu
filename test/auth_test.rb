# frozen_string_literal: true

require 'logger'
require 'test_helper'

AUTH_LOGGER = 'auth_test.log'
File.delete(AUTH_LOGGER) if File.exist?(AUTH_LOGGER)

describe 'auth' do
  before do
    Hudu.reset
    Hudu.logger = Logger.new(AUTH_LOGGER)
  end
  it '#0 check required params' do
    c = Hudu.client
    # missing endpoint
    assert_raises ArgumentError do
      c.login
    end
  end
  it '#1 check required params' do
    Hudu.configure do |config|
      config.endpoint = ENV['HUDU_API_HOST']
    end
    c = Hudu.client
    # missing access_token
    assert_raises ArgumentError do
      c.login
    end
  end
  it '#2 wrong credentials' do
    Hudu.configure do |config|
      config.endpoint = ENV['HUDU_API_HOST']
      config.api_key = 'api-key-token'
    end
    c = Hudu.client
    assert_raises Hudu::AuthenticationError do
      c.login
    end
  end
  it '#3 logged in' do
    Hudu.configure do |config|
      config.endpoint = ENV['HUDU_API_HOST']
      config.api_key = ENV['HUDU_API_KEY']
    end
    c = Hudu.client

    refute_empty c.login, '.login'
  end
end
