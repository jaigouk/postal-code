lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

ENV["RACK_ENV"] ||= "development"

if ENV["RACK_ENV"] == "development"
  require "dotenv"
  Dotenv.load(".env")
end

require "post_codes"
