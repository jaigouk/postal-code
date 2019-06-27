# frozen_string_literal: tur

require 'yaml'

module SaveFixture
  def save_fixture(name, hash_data)
    raw_data = hash_data.to_yaml
    target = File.expand_path("spec/fixtures/#{name}.yml")

    File.open(target, 'w') do |f|
      f.write(raw_data)
    end
  end
end
