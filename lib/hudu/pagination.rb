require 'uri'
require 'json'

module Hudu

  # Defines HTTP request methods
  # @see https://support.hudu.com/hc/en-us/articles/11422780787735-REST-API#pagination-0-5
  module RequestPagination

    class PagingInfoPager
      attr_reader :offset, :limit, :total
      def initialize(page_size)
        @page = 1
        @page_total = @page_size = page_size
      end

      def page_options
        { page: @page }
      end

      def next_page!(body)
        @page += 1
        a = PagingInfoPager.data(body)
        @page_total = a.is_a?(Array) ? a.count : 1
      end

      def more_pages?
        # while full page we have next page
        @page_total == @page_size
      end

      def self.data(body) 
        # assume hash {"resource":[...]}, get first key and return array data
        k,v = body.first
        if v.is_a?(Array) || v.is_a?(Hash)
          v
        else
          body
        end
      end
    end
  end
end
