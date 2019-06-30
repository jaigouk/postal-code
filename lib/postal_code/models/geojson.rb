# frozen_string_literal: true

module PostalCode
  # Geojson
  # full data source
  class Geojson < ActiveRecord::Base
    self.table_name = 'geojson'
  end
end
