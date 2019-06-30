# frozen_string_literal: true

module PostalCode
  class Name < ActiveRecord::Base
    self.table_name = "names"
  end
end