# frozen_string_literal: true

require 'httparty'
require 'oj'

module PostCodes
  # MapboxClient
  # consumes api from mapbox
  class Geocoding
    SEARCH_TYPES = %w[
      country region postcode district place
      locality neighborhood address poi
    ].freeze

    def initialize(lon, lat, keyword, types = '')
      @lon = lon
      @lat = lat
      @keyword = keyword
      @params = {}
      @types = types
    end

    def respond
      res = ask_mapbox(:search)
      return unless res.code == 200

      self.class.group_by_postcode Oj.load(res.body)
    end

    def country_code
      res = ask_mapbox(:reverse)
      return unless res.code == 200

      data = Oj.load(res.body)
      return if data['features'].size.zero?

      "&country=#{data['features'].first['properties']['short_code']}"
    end

    class << self
      def group_by_postcode(data)
        return unless data['features']

        filtered(data).group_by { |x| x['postcode'] }
      end

      private

      def filtered(data)
        temp = data['features'].map do |f|
          f.select { |k, _| %w[text context place_name].include?(k) }
        end
        temp.each { |item| item['postcode'] = postcode(item) }
        temp.map do |h|
          h.select { |k, _| %w[text postcode].include?(k) }
        end
      end

      def postcode(item)
        post = item['context'].select { |i| i['id'].include?('postcode') }
        return post[0]['text'] unless post.size.zero?

        'FIX_BLANK_POSTCODE'
      end
    end

    private

    def ask_mapbox(request_type)
      req = request_type == :reverse ? country_url : search_url
      HTTParty.send(:get, req, @params)
    end

    def sanitized_types
      if [@types.split(',') - SEARCH_TYPES].size.zero?
        "?types=#{@types}"
      else
        ''
      end
    end

    def country_url
      "#{PostCodes.settings[:mapbox][:base_url]}/geocoding/v5/" \
      "#{PostCodes.settings[:mapbox][:endpoint]}/#{@lon},#{@lat}.json" \
      "?types=country#{token_part}"
    end

    def search_url
      "#{PostCodes.settings[:mapbox][:base_url]}/geocoding/v5/" \
      "#{PostCodes.settings[:mapbox][:endpoint]}/#{@keyword}.json" \
      "?proximity=#{@lon},#{@lat}#{sanitized_types}" \
      "&language=en#{country_code}#{token_part}"
    end

    def token_part
      "&access_token=#{PostCodes.settings[:mapbox][:token]}"
    end
  end
end
