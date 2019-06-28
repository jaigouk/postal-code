# frozen_string_literal: true

require_relative 'lib/post_codes'
require "active_record_migrations"

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'json'
require 'pathname'


ActiveRecordMigrations.configure do |c|
  c.schema_format = :ruby
  c.yaml_config = PostCodes::DB_CONFIG
  c.environment = PostCodes.env
end

ActiveRecordMigrations.load_tasks

RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
end

task quality: %i[rubocop]
task default: %i[spec quality]

load 'tasks/wof.rake'
