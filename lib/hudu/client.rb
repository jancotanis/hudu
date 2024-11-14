# frozen_string_literal: true

require File.expand_path('api', __dir__)
require File.expand_path('asset_helper', __dir__)

module Hudu
  # The Client class serves as a wrapper for the Hudu REST API, providing methods to interact 
  # with various Hudu resources.
  #
  # This class dynamically defines methods to fetch, create, update, and manipulate Hudu resources 
  # such as companies, articles, assets, and more.
  #
  # @example Basic Usage
  #   client.companies # Fetch all companies
  #   client.company(1) # Fetch a company by ID
  #   client.update_company(1, { name: "Updated Company" }) # Update a company
  #   client.create_company({ name: "New Company" }) # Create a new company
  class Client < API

    # Dynamically defines methods for interacting with Hudu API resources.
    #
    # Depending on the arguments, this will define methods to:
    # - Fetch all records for a resource
    # - Fetch a specific record by ID
    # - Update a record
    # - Create a new record
    #
    # @param method [Symbol] The method name for fetching all records.
    # @param singular_method [Symbol, nil] The method name for fetching a single record by ID. Optional.
    # @param path [String] The API path for the resource. Defaults to the method name.
    #
    # @example Defining endpoints
    #   api_endpoint :companies, :company
    #   # Defines:
    #   # - `companies(params = {})` to fetch all companies.
    #   # - `company(id, params = {})` to fetch a single company by ID.
    #   # - `update_companies(id, params = {})` to update a company.
    #   # - `create_companies(params = {})` to create a new company.
    def self.api_endpoint(method, singular_method = nil, path = method)
      if singular_method
        # Define method to fetch all records and one by id
        send(:define_method, method) do |params = {}|
          r = get_paged(api_url(path), params)
          hudu_data(r, method)
        end
        # Define method to fetch a single record by ID
        send(:define_method, singular_method) do |id, params = {}|
          r = get(api_url("#{path}/#{id}"), params)
          hudu_data(r, singular_method)
        end
      else
        # Define simple method to fetch data
        send(:define_method, method) do |params = {}|
          get(api_url(path), params)
        end
      end

      # Define method to update a record
      send(:define_method, "update_#{method}") do |id = nil, params = {}|
        r = put(api_url("#{path}/#{id}"), params)
        hudu_data(r, method)
      end

      # Define method to create a record
      send(:define_method, "create_#{method}") do |id = nil, params = {}|
        r = post(api_url("#{path}/#{id}"), params)
        hudu_data(r, method)
      end
    end


    # Define API endpoints for various resources
    api_endpoint :api_info
    api_endpoint :activity_logs
    api_endpoint :companies, :company
    api_endpoint :articles, :article
    api_endpoint :asset_layouts, :asset_layout
    api_endpoint :assets, :asset
    api_endpoint :asset_passwords, :asset_password
    api_endpoint :folders, :folder
    api_endpoint :procedures, :procedure
    api_endpoint :expirations
    api_endpoint :websites, :website
    api_endpoint :relations
    api_endpoint :magic_dashes, :magic_dash, 'magic_dash'

    # Fetches all articles for a specific company.
    #
    # @param company_id [Integer] The ID of the company.
    # @param params [Hash] Additional query parameters.
    # @return [Array<Hash>] A list of articles.
    def company_articles(company_id, params = {})
      articles({ company_id: company_id }.merge(params))
    end

    # Fetches all assets for a specific company.
    #
    # @param id [Integer] The ID of the company.
    # @param params [Hash] Additional query parameters.
    # @return [Array<Hash>] A list of assets.
    def company_assets(id, params = {})
      get_paged(api_url("companies/#{id}/assets"), params)
    end

    # Fetches a specific asset for a company.
    #
    # @param company_id [Integer] The ID of the company.
    # @param asset_id [Integer] The ID of the asset.
    # @param params [Hash] Additional query parameters.
    # @return [Hash] The asset details.
    def company_asset(company_id, asset_id, params = {})
      get(api_url("companies/#{company_id}/assets/#{asset_id}"), params)
    end

    # Updates an existing company asset.
    #
    # @param asset [Object] The asset object to update.
    # @return [Hash] The updated asset data.
    def update_company_asset(asset)
      hudu_data(put(api_url("companies/#{asset.company_id}/assets/#{asset.id}"), AssetHelper.construct_asset(asset), false), :asset)
    end

    # Creates a new asset for a company.
    #
    # @param company_id [Integer] The ID of the company.
    # @param asset_layout [Object] The asset layout object.
    # @param fields [Array<Hash>] The custom fields for the asset.
    # @return [Hash] The newly created asset data.
    def create_company_asset(company_id, asset_layout, fields)
      hudu_data(post(api_url("companies/#{company_id}/assets"), AssetHelper.create_asset(asset_layout.name, asset_layout.id, fields), false), :asset)
    end

    # Constructs the full API URL for a given path.
    #
    # @param path [String] The API path.
    # @return [String] The full API URL.
    def api_url(path)
      "/api/v1/#{path}"
    end

    # Extracts resource data from the API response.
    #
    # @param result [Hash, Object] The API response.
    # @param resource [Symbol] The name of the resource to extract.
    # @return [Object] The resource data.
    def hudu_data(result, resource)
      if result.is_a?(WrAPI::Request::Entity) && result.attributes[resource.to_s]
        result.send resource.to_s
      else
        result
      end
    end
  end
end
