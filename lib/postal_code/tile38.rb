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

      private

      def parse_result(res)
        return { error: 'not_found' } if res.nil?
        return { success: 'set the data' } if res == 'OK'

        Oj.load(res)
      end
    end
  end
end
