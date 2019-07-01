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

    get('/:search') do
      content_type :json

      keyword = params[:search]
      lat = params[:lat]
      lon = params[:lng]

      PostalCode::Geocoding.new(lon,lat,keyword).respond.to_json
    end
  end
end
