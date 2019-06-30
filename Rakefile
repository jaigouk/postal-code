# frozen_string_literal: true

require 'rspec/core/rake_task'
require_relative 'lib/postal_code'
require 'active_record_migrations'

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

load 'tasks/wof.rake'
require 'rubocop/rake_task'
require 'json'
require 'pathname'

ActiveRecordMigrations.configure do |c|
  c.schema_format = :ruby
  c.yaml_config = PostalCode::DB_CONFIG
  c.environment = PostalCode.env
end

ActiveRecordMigrations.load_tasks

RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
end

task quality: %i[rubocop]
task default: %i[spec quality]
