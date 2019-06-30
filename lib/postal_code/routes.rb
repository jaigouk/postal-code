# frozen_string_literal: true

require 'rack/contrib'
require 'sinatra/base'

require_relative '../postal_code'

module PostalCode
  # Application routes
  class Routes < Sinatra::Base
    enable :sessions
    use Rack::PostBodyContentTypeParser
    set :environment, ENV['RACK_ENV']
    enable :digest_assets

    get('/ping') {}

    get('/') do
      json = PostalCode::Geojson.first&.body || ''
      body("returned results are..\n #{json}")
      status 200
    end
  end
end