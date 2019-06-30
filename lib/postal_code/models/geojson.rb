# frozen_string_literal: true

module PostalCode
  class Geojson < ActiveRecord::Base
    self.table_name = "geojson"
  end
end