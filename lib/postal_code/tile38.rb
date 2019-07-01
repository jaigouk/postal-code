# frozen_string_literal: true

require 'redis'
require 'oj'

module PostalCode
  # Tile38
  # insert poloygons and check point
  class Tile38
    class << self
      attr_accessor :redis, :namespace

      def all
        redis.keys(namespaced_key('*'))
      end

      def namespaced_key(*keys)
        [namespace, *keys].compact.join(':')
      end

      def set(*arg)
        res = redis.call(arg.prepend(:set))
        parse_result(res)
      rescue StandardError => e
        { error: e.message }
      end

      def get(*arg)
        res = redis.call(arg.prepend(:get))
        parse_result(res)
      rescue StandardError => e
        { error: e.message }
      end

      def del(key)
        res = redis.call(:del, key)
        parse_result(res)
      rescue StandardError => e
        { error: e.message }
      end

      # geojson part is json string.
      # For a given hash like this,
      # hash = {type: 'Point', coordinates: [134.9583232, 34.6658157]}
      # hash.to_json should be the argument for the geojson
      #
      # https://github.com/tidwall/tile38#geojson
      # mportant to note that all coordinates are in Longitude, Latitude order.
      # If it's a valid geojson, then it's ok to use.
      def insert_geojson(namespace:, key:, geojson:)
        set(namespace, key, 'OBJECT', geojson)
      end

      # range 20000 m by default.
      # results are sorted for nearest ones first by default.
      #
      # Usage:
      #   PostalCode::Tile38.nearby(key: 'postalcode',
      #                             lat: 34.6658157, lon: 134.9583232)
      def nearby(key:, lat:, lon:, range: '2000')
        cmd = [:nearby, key, 'LIMIT', 5, 'POINT', lat, lon, range]
        res = redis.call(cmd)[1]
        first_result = res.blank? ? [] : res.first[1]
        parse_result(first_result)
      end

      def scan(key)
        redis.call([:scan, key])
      end

      def country_for(lat:, lon:)
        res = redis.call([:nearby, 'country', 'LIMIT', 1, 'POINT', lat, lon])[1]
        parse_result(res.first[1])
      end

      private

      def parse_result(res)
        return { error: 'not_found' } if res.blank?
        return { success: 'set the data' } if res == 'OK'

        Oj.load(res)
      end
    end
  end
end
