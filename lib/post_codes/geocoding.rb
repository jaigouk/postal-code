# frozen_string_literal: true

require 'httparty'
require 'oj'

module PostCodes
  # MapboxClient
  # consumes api from mapbox
  class Geocoding
    HTTPARTY_PARAMS =
      %i[headers query body verify timeout follow_redirects].freeze

    def initialize(lon, lat, keyword, range = 'country')
      @lon = lon
      @lat = lat
      @keyword = keyword
      @params = {}
      @search_range = range
    end

    def respond
      res = ask_mapbox(:search)
      return unless res.code == 200
      Oj.load(res.body)
    end

    def get_country_code
      res = ask_mapbox(:reverse)
      return unless res.code == 200
      data = Oj.load(res.body)
      return if data['features'].size == 0
      code =  data['features'].first['properties']['short_code']

      "&country=#{code}"
    end

    def self.group_by_postcode(data)
      return unless data['features']
      temp = data['features'].map do |f|
        f.select { |k, _| %w[text context].include?(k) }
      end

      temp.each do |item|
        item['postcode'] =
          if item['context'].first['id'].include?('postcode')
            item['context'].first['text']
          else
            ''
          end
      end

      temp.map do |h|
        h.select { |k, _| %w[text postcode].include?(k) }
      end.group_by { |x| x['postcode'] }
    end

    private

    def ask_mapbox(request_type)
      req = request_type == :reverse ? reverse_url : search_url
      HTTParty.send(:get, req, @params)
    end

    def reverse_url
      "#{base_url}/geocoding/v5/#{endpoint}/#{@lon},#{@lat}.json?types=#{@search_range}#{token_part}"
    end

    def search_url
      "#{base_url}/geocoding/v5/#{endpoint}/#{@keyword}.json#{proximity}#{get_country_code}#{token_part}"
    end

    def proximity
      "?proximity=#{@lon},#{@lat}"
    end

    def token_part
      "&access_token=#{PostCodes.settings[:mapbox][:token]}"
    end

    def base_url
      PostCodes.settings[:mapbox][:base_url]
    end

    def endpoint
      PostCodes.settings[:mapbox][:endpoint]
    end

    def httparty_params
      @params.select { |key| HTTPARTY_PARAMS.include?(key) }
    end

    def response_headers
      @httparty_response.headers
    end
  end
end
