# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'post_codes'
require 'rack/test'
require 'factory_bot'
require 'faker'
require 'pry'
require 'webmock/rspec'
require 'support/vcr'
require 'support/save_fixture'

%w[support setup shared].each do |folder|
  Dir[File.join(__dir__, folder, '**/*.rb')].each { |file| require file }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods
  config.include SaveFixture

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching(:focus)
  config.warnings = false
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random

  # required for --only-failures flag to be working
  config.example_status_persistence_file_path = 'tmp/examples.txt'

  Kernel.srand(config.seed)

  def app
    described_class
  end
end
