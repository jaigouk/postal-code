# frozen_string_literal: true

require 'httparty'

module PostCodes
  # MapboxClient
  # consumes api from mapbox
  class MapboxClient
    HTTPARTY_PARAMS =
      %i[headers query body verify timeout follow_redirects].freeze

    def initialize(method, url, params = {})
      @method = method.to_sym
      @url    = url
      @params = params
    end

    class << self
      alias request new
    end

    def response
      HTTParty.send(@method, @url, httparty_params)
    end

    private

    def httparty_params
      @params.select { |key| HTTPARTY_PARAMS.include?(key) }
    end

    def response_headers
      @httparty_response.headers
    end
  end
end
