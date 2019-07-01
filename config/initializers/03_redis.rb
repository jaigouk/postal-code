# frozen_string_literal: true

require 'redis'
require_relative '../../lib/postal_code/tile38'

# Redis.current = Redis.new(url: ENV.fetch('REDIS_URL'))
host = ENV['REDIS_HOST'] || 'localhost'
port = ENV['REDIS_PORT']&.to_i || 9851
db =  ENV['REDIS_DB']&.to_i || 0

redis = Redis.new(host: host, port: port, db: db)
PostalCode::Tile38.redis = redis
PostalCode::Tile38.namespace = 'tile38'
