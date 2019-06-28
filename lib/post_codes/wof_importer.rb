# frozen_string_literal: true

module PostCodes
  # WofImporter
  # downloads db and import it
  class WofImporter
    def initialize(country)
      @country = country
    end

    def download
      fetch(db('admin'))
      fetch(db('postalcode'))
    end

    def migrate_wof_db
      migrate(db('admin'))
      migrate(db('postalcode'))
    end

    private

    def fetch(db)
      f = "#{PostCodes::DATA_PATH}/#{db}"
      run_system(db) unless File.file?(f)
    end

    def migrate(db)
      f = "#{PostCodes::DATA_PATH}/#{db}"
      migrate_system(db) if File.file?(f)
    end

    def run_system(db)
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
