# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'yaml'

require_relative 'postal_code/geocoding'
require_relative 'postal_code/wof_importer'
require_relative 'postal_code/models/ancestor'
require_relative 'postal_code/models/concordance'
require_relative 'postal_code/models/geojson'
require_relative 'postal_code/models/name'
require_relative 'postal_code/models/spr'
require_relative 'postal_code/routes'
require_relative 'postal_code/tile38'

# PostalCode
#
module PostalCode
  ENV_VARIABLE_NAME = 'RACK_ENV'
  DEVELOPMENT_ENV = 'development'
  TEST_ENV = 'test'
  SANDBOX_ENV = 'sandbox'
  PRODUCTION_ENV = 'production'

  ROOT_PATH = Pathname(__dir__).parent
  DB_CONFIG = ROOT_PATH.join('config', 'database.yml')
  LOAD_PATH = ROOT_PATH.join('lib')
  CONFIG_PATH = ROOT_PATH.join('config')
  WOF_PATH = ROOT_PATH.join('bin', 'wof')
  DATA_PATH = ROOT_PATH.join('data')
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

PostalCode.add_to_load_path!
PostalCode.initialize!
