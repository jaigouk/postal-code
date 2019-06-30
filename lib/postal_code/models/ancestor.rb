# frozen_string_literal: true

module PostalCode
  # Acestor shows relationships
  class Ancestor < ActiveRecord::Base
    self.table_name = 'ancestors'
  end
end
