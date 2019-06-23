# frozen_string_literal: true

require 'httparty'

module PostCodes
  class MapboxClient
    HTTPARTY_PARAMS = [:headers, :query, :body, :verify, :timeout, :follow_redirects]

    def initialize(method, url, params = {})
      @method = method.to_sym
      @url    = url
      @params = params
    end

    class << self
      alias_method :request, :new
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
