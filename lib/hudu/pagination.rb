# frozen_string_literal: true

require 'uri'
require 'json'

module Hudu
  # Defines HTTP request methods
  # @see https://support.hudu.com/hc/en-us/articles/11422780787735-REST-API#pagination-0-5
  module RequestPagination
    # The PagingInfoPager class provides a mechanism to handle pagination information for API responses.
    #
    # It manages the current page, page size, and provides utilities for determining if there are more pages to fetch.
    #
    # @example Basic Usage
    #   pager = PagingInfoPager.new(50)
    #   while pager.more_pages?
    #     response = api_client.get_data(pager.page_options)
    #     pager.next_page!(response.body)
    #   end
    class PagingInfoPager
      attr_reader :offset, :limit, :total

      # Initializes a new PagingInfoPager instance.
      #
      # @param page_size [Integer] The number of records to fetch per page.
      def initialize(page_size)
        @page = 1
        @page_total = @page_size = page_size
      end

      # Provides the current pagination parameter options for each rest request.
      #
      # @return [Hash] A hash containing the current page and page size.
      #
      # @example
      #   pager.page_options # => { page: 1, page_size: 50 }
      def page_options
        { page: @page, page_size: @page_size }
      end

      # Advances to the next page based on the response body and updates internal pagination state.
      #
      # @param body [Hash] The response body from the API, expected to contain a paginated resource.
      # @return [Integer] The updated page total, typically the count of items on the current page.
      #
      # @example
      #   response_body = { "items" => [...] }
      #   pager.next_page!(response_body)
      def next_page!(body)
        @page += 1
        a = PagingInfoPager.data(body)
        @page_total = a.is_a?(Array) ? a.count : 1
      end

      # Determines whether there are more pages to fetch.
      #
      # @return [Boolean] Returns `true` if the current page is full, indicating another page might exist.
      #
      # @example
      #   pager.more_pages? # => true or false
      def more_pages?
        # while full page we have next page
        @page_total == @page_size
      end

      # Extracts paginated data from the response body.
      #
      # @param body [Hash] The response body containing resource data, expected to be in a hash format.
      # @return [Array, Hash, Object] Returns the extracted data, which could be an array, hash, or other object.
      #
      # @example
      #   response_body = { "items" => [1, 2, 3] }
      #   PagingInfoPager.data(response_body) # => [1, 2, 3]
      def self.data(body)
        # assume hash {"resource":[...]}, get first key and return array data
        result = body
        if result.respond_to?(:first)
          _k, v = body.first
          result = v if v.is_a?(Array) || v.is_a?(Hash)
        end
        result
      end
    end
  end
end
