# frozen_string_literal: true

unless PostalCode.production?
  require 'dotenv'
  Dotenv.load
end
