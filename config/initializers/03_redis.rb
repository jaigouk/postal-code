# frozen_string_literal: true

require 'redis'
require_relative '../../lib/postal_code/tile38'

# Redis.current = Redis.new(url: ENV.fetch('REDIS_URL'))
redis = Redis.new(host: 'localhost', port: 9851, db: 0)
PostalCode::Tile38.redis = redis
PostalCode::Tile38.namespace = 'tile38'
