# frozen_string_literal: true

module PostCodes
  class WofImporter
    def initialize(country)
      @country = country
    end

    def download
      fetch(db('admin'))
      fetch(db('postalcode'))
    end

    def fetch(db)
      unless File.file?("#{PostCodes::DATA_PATH}/#{db}")
        run_system_command(db)
      end
    end

    def run_system_command(db)
      req = "#{PostCodes::WOF_PATH}/wof-dist-fetch-darwin " \
      '-inventory https://dist.whosonfirst.org/sqlite/inventory.json ' \
      "-dest #{PostCodes::DATA_PATH} " \
      "-include '#{db}'"
      system(req)
    end

    def db(type)
      "whosonfirst-data-#{type}-#{@country}-latest.db"
    end
  end
end
