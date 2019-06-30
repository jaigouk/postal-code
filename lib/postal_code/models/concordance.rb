# frozen_string_literal: true

module PostalCode
  # Concordance
  # shows other sources of the data
  class Concordance < ActiveRecord::Base
    self.table_name = 'concordances'
  end
end
