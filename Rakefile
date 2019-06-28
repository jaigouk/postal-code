# frozen_string_literal: true

require_relative "lib/post_codes"

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'json'
require 'pathname'

RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--display-cop-names']
end

task quality: %i[rubocop]
task default: %i[spec quality]

load "tasks/wof.rake"
