# frozen_string_literal: true

require 'faraday'
require 'dotenv'
require 'logger'
require 'date'
require 'test_helper'

CLIENT_LOGGER = 'client_test.log'
File.delete(CLIENT_LOGGER) if File.exist?(CLIENT_LOGGER)
TEST_COMPANY_ID = ENV['HUDU_TEST_COMPANY_ID']

describe 'client' do
  before do
    Hudu.configure do |config|
      config.endpoint = ENV['HUDU_API_HOST'].downcase
      config.api_key = ENV['HUDU_API_KEY']
      config.logger = Logger.new(CLIENT_LOGGER)
    end
    @client = Hudu.client
    @client.login
  end

  it '#1 GET api info' do
    info = @client.api_info
    test_version = '2.2'
    assert info.version >= test_version, "version(#{info.version}) >= #{test_version}"
  end
  it '#2 GET activity_logs' do
    # just get them and try a parameter
    logs_count = @client.activity_logs({ start_date: DateTime.now }).count
    assert logs_count < 10, 'not too much logs'

    # from yesterday
    logs = @client.activity_logs({ start_date: (DateTime.now - 1) })
    assert logs.count >= logs_count, 'more activity logs since yesterday'
  end
  it '#3 GET companies' do
    # just get them and try a parameter
    companies = @client.companies
    assert companies.count.positive?, '.companies found'

    first_id = companies.first.id
    company = @client.company(first_id)

    assert value(company.id).must_equal first_id, 'must find company by id'
    assert company.full_url.downcase[@client.endpoint], "full_url #{company.full_url} must include #{@client.endpoint}"
  end
  it '#4 GET assets' do
    # just get them and try a parameter
    assets = @client.company_assets(TEST_COMPANY_ID)
    assets.each do |asset|
      _layout = @client.asset_layout(asset.asset_layout_id)
      # puts "#{layout.name}: '#{asset.name}'"
      # puts '=================================================='
      asset.fields.each do |field|
        # v = field.value || ''
        # puts " #{field.position.to_s.rjust(3)} #{field.label}: '#{v[0..40]}'"
      end
    end
  end
  it '#5 GET folders' do
    # just get them and try a parameter
    folders = @client.folders
    assert folders.count.positive?, '.folders found'

    first_id = folders.first.id
    folder = @client.folder(first_id)

    assert value(folder.id).must_equal first_id, 'must find folder by id'
  end
  it '#6 GET procedures' do
    # just get them and try a parameter
    procedures = @client.procedures
    assert procedures.count.positive?, '.procedures found'

    first_id = procedures.first.id
    procedure = @client.procedure(first_id)

    assert value(procedure.id).must_equal first_id, 'must find procedure by id'
  end
  it '#7 GET websites' do
    # just get them and try a parameter
    websites = @client.websites
    assert websites.count.positive?, '.websites found'

    first_id = websites.first.id
    website = @client.website(first_id)

    assert value(website.id).must_equal first_id, 'must find website by id'
  end
  it '#8 GET relations' do
    # just get them and try a parameter
    relations = @client.relations
    assert relations.count.positive?, '.relations found'
  end
  it '#9 GET expirations' do
    # just get them and try a parameter
    expirations = @client.expirations
    assert expirations.count.positive?, '.expirations found'
  end
  it '#10 GET asset_passwords' do
    # just get them and try a parameter
    asset_passwords = @client.asset_passwords
    assert asset_passwords.count.positive?, '.asset_passwords found'
  rescue Faraday::UnauthorizedError
    puts 'Cannot test client.asset_passwords due to authorisation issue in test account'
  end
end
