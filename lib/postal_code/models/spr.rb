# frozen_string_literal: true

module PostalCode
  # Spr
  # flattened version of geojson data
  class Spr < ActiveRecord::Base
    self.table_name = 'spr'
  end
end
