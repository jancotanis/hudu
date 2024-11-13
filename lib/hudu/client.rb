require File.expand_path('api', __dir__)
require File.expand_path('asset_helper', __dir__)

module Hudu
  # Wrapper for the Hudu REST API
  #
  # @see 
  class Client < API

  private
    def self.api_endpoint(method, singular_method = nil, path = method)
      # generate all and by id
      if singular_method
        # all records
        self.send(:define_method, method) do |params = {}|
          r = get_paged(api_url(path), params)
          r = hudu_data(r,method)
        end
        # record by id
        self.send(:define_method, singular_method) do |id, params = {}|
          r = get(api_url("#{path}/#{id}"), params)
          r = hudu_data(r,singular_method)
        end
      else
        # normal method, return result
        self.send(:define_method, method) do |params = {}|
          get(api_url(path), params)
        end
      end
      # update
      self.send(:define_method, "update_#{method}") do |id=nil,params = {}|
        r = put(api_url("#{path}/#{id}"), params)
        r = hudu_data(r,method)
      end
      # create
      self.send(:define_method, "create_#{method}") do |id=nil,params = {}|
        r = post(api_url("#{path}/#{id}"), params)
        r = hudu_data(r,method)
      end
      
    end

  public
    api_endpoint :api_info
    
    # Activity logs can be filtered on
    #  user_id, user_email
    #  resource_id, resource_type
    #  action_message
    #  start_date - Must be in ISO 8601 format
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

    def company_articles( company_id, params = {} )
      articles({company_id: company_id}.merge(params))
    end
    def company_assets(id,params={})
      get_paged(api_url("companies/#{id}/assets"), params)
    end
    def company_asset(company_id,asset_id,params={})
      get(api_url("companies/#{company_id}/assets/#{asset_id}"), params)
    end

    def update_company_asset(asset)
      hudu_data(put(api_url("companies/#{asset.company_id}/assets/#{asset.id}"), AssetHelper.construct_asset(asset),false),:asset)
    end

    def create_company_asset(company_id,asset_layout, fields)
      hudu_data(post(api_url("companies/#{company_id}/assets"), AssetHelper.create_asset(asset_layout.name,asset_layout.id,fields),false),:asset)
    end

    # return api path
    def api_url path
      "/api/v1/#{path}"
    end

    # hudu returns data as {resource:{}} or {resource:[]} 
    def hudu_data(result,resource)
      if result.is_a?(WrAPI::Request::Entity) && result.attributes[resource.to_s]
        result.send resource.to_s
      else
        result
      end
    end
  end
end
