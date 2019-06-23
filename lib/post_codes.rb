# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'yaml'

# PostCodes
#
module PostCodes
  ENV_VARIABLE_NAME = 'RACK_ENV'
  DEVELOPMENT_ENV = 'development'
  TEST_ENV = 'test'
  SANDBOX_ENV = 'sandbox'
  PRODUCTION_ENV = 'production'

  ROOT_PATH = Pathname(__dir__).parent
  LOAD_PATH = ROOT_PATH.join('lib')
  CONFIG_PATH = ROOT_PATH.join('config')
  INITIALIZERS_PATH = CONFIG_PATH.join('initializers')

  LOG_DIR_PATH = ROOT_PATH.join('log')

  LOG_FILE_PATH = begin
    FileUtils.mkdir_p(LOG_DIR_PATH)
    LOG_DIR_PATH.join('logstash.log').tap do |path|
      FileUtils.touch(path)
    end
  end

  class << self
    def env
      ENV[ENV_VARIABLE_NAME] || DEVELOPMENT_ENV
    end

    def env?(*args)
      args.map(&:to_s).include?(env)
    end

    def add_to_load_path!
      $LOAD_PATH.unshift(LOAD_PATH) unless $LOAD_PATH.include?(LOAD_PATH)
    end

    def initialize!
      INITIALIZERS_PATH.children.sort.each { |file| require file }
    end

    def production?
      ![DEVELOPMENT_ENV, TEST_ENV].include?(env)
    end

    def settings
      @settings ||= begin
        config_file_path = CONFIG_PATH.join('config.yml.erb')
        file_to_read = ERB.new(File.read(config_file_path)).result
        YAML.safe_load(file_to_read).with_indifferent_access
      end
    end
  end
end

PostCodes.add_to_load_path!
PostCodes.initialize!

require_relative 'post_codes/mapbox_client'
