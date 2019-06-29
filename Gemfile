# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.6.3'

# Core
gem 'rack-contrib'
gem 'httparty'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-attack', require: 'rack/attack'
gem 'puma'
gem 'sinatra'

gem 'addressable'
gem 'dotenv'
gem 'oj'

# db
gem 'redis'
gem 'pg'
gem 'sqlite3'
gem 'activerecord'
gem 'active_record_migrations'
gem 'activesupport'
gem 'activerecord-postgis-adapter'
gem 'activerecord-import'

# util
gem 'rake'
gem 'danger'
gem 'danger-commit_lint'

group :development do
  gem 'rerun'
  # sequel is used dev mode.
  # just to inspect sqlite schema
  gem 'sequel'
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
