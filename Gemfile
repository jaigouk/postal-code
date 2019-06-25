# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.6.3'

# Core
gem 'rack-contrib'
gem 'httparty'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-attack', require: 'rack/attack'
gem 'rake'
gem 'puma'

gem 'sinatra'
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
  gem 'guard-rspec', require: false
  gem 'guard-bundler'
  gem 'guard-rubocop'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec'
  gem 'rubocop'
  gem 'hashdiff'
  gem 'vcr'
  gem 'webmock', require: false
  gem 'timecop'
end
