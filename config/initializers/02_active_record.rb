# frozen_string_literal: true

require 'active_record'
require 'erb'

# rubocop:disable Security/YAMLLoad
db_config = YAML.load(ERB.new(File.read(PostalCode::DB_CONFIG)).result)
ActiveRecord::Base.configurations = db_config
ActiveRecord::Base.establish_connection(PostalCode.env.to_sym)
# rubocop:enable Security/YAMLLoad
