# frozen_string_literal: true

module PostalCode
  class Ancestor < ActiveRecord::Base
    self.table_name = "ancestors"
  end
end
