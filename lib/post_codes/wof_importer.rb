# frozen_string_literal: true

module PostCodes
  # WofImporter
  # downloads db and import it
  class WofImporter
    def initialize(country)
      @country = country
      @db_types = [db_type('admin'), db_type('postalcode')]
    end

    def download
      @db_types.each { |t| fetch(t) }
    end

    def export_to_csv
      @db_types.each { |t| convert_to_csv(t) }
    end

    private

    def fetch(db)
      file = "#{PostCodes::DATA_PATH}/#{db}"
      return if File.file?(file)

      req = "#{PostCodes::WOF_PATH}/wof-dist-fetch-darwin " \
      '-inventory https://dist.whosonfirst.org/sqlite/inventory.json ' \
      "-dest #{PostCodes::DATA_PATH} " \
      "-include '#{db}'"
      system(req)
    end

    def convert_to_csv(db)
      file = "#{PostCodes::DATA_PATH}/#{db}"
      return unless File.file?(file)

      cmd = "#{PostCodes::WOF_PATH}/convert-db-to-csv.sh " \
      "#{PostCodes::DATA_PATH}/#{db}"
      system(cmd)

      csv_dir = csv_data_dir(db)
      system("mkdir -p #{csv_dir}")
      system("mv #{PostCodes::ROOT_PATH}/*.csv #{csv_dir}")
    end

    def db_type(type)
      "whosonfirst-data-#{type}-#{@country}-latest.db"
    end

    def csv_data_dir(db)
      "#{PostCodes::DATA_PATH}/#{extract_type(db)}"
    end

    def extract_type(db_str)
      db_str.gsub('whosonfirst-data-', '').gsub("-#{@country}-latest.db", '')
    end
  end
end
