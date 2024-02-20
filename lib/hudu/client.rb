require File.expand_path('api', __dir__)

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
          r = get(api_url("#{path}/" + id.to_s), params)
          r = hudu_data(r,singular_method)
        end
      else
        # normal method, return result
        self.send(:define_method, method) do |params = {}|
          get(api_url(path), params)
        end
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

    def company_articles( company_id, params = {} )
      articles({company_id: company_id}.merge(parems))
    end
    
    def company_assets(id,params={})
      get_paged(api_url("companies/#{id}/assets"), params)
    end
    def company_asset(id,asset_id,params={})
      get(api_url("companies/#{id}/assets/#{asset_id}"), params)
    end

    # return api path
    def api_url path
      "/api/v1/#{path}"
    end

    # hudu returns data as {resource:{}} or {resource:[]} 
    def hudu_data(result,resource)
      if result.is_a?(Hash) && result[resource.to_s]
        result[resource.to_s]
      else
        result
      end
    end
  end
end
