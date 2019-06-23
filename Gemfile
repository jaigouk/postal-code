# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.6.3'

# Core
gem 'sinatra'
gem 'rack-contrib'
gem 'httparty'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-attack', require: 'rack/attack'
gem 'rake'
gem 'puma'

gem 'addressable'
gem 'dotenv'
gem 'oj'

gem 'danger'
gem 'danger-commit_lint'

group :development do
  gem 'rerun'
end

group :development, :test do
  gem 'faker'
  gem 'pry-byebug'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec'
  gem 'rubocop'
  gem 'hashdiff'
  gem 'webmock', require: false
  gem 'timecop'
end
