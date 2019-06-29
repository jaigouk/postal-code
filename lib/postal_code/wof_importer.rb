# frozen_string_literal: true

require 'csv'
require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'

module PostalCode
  # WofImporter
  # downloads db and import it
  class WofImporter
    ANCESTOR_HEADERS = %w[id ancestor_id ancestor_placetype lastmodified].freeze
    CONCORDANCE_HEADERS = %w[id other_id other_source lastmodified].freeze
    GEOJSON_HEADERS = %w[id body lastmodified].freeze
    NAMES_HADERS = %w[id placetype country language extlang script region
                      variant extension privateuse name lastmodified].freeze
    SPR_HEADERS = %w[id parent_id name placetype country repo latitude
                     longitude min_latitude min_longitude max_latitude
                     max_longitude is_current is_deprecated is_ceased
                     is_superseded is_superseding superseded_by supersedes
                     lastmodified].freeze
    TABLES = %w[ancestors concordances geojson names spr].freeze

    def initialize(country)
      @country = country
      @db_types = [db_type('admin'), db_type('postalcode')]
    end

    def download
      @db_types.each { |t| fetch(t) }
    end

    def export_wof_to_csv
      @db_types.each { |t| convert_to_csv(t) }
    end

    def import_wof_csv
      %w[admin postalcode].each { |t| read_csv_and_save(t) }
    end

    private

    def read_csv_and_save(type)
      
      return unless File.directory?(csv_data_dir(type))
      
      TABLES.map { |x| "#{x}.csv" }.each do |t|        
        file = "#{PostalCode::DATA_PATH}/#{type}/#{t}"
        if File.file?(file)
          read_csv(file)
        end
      end
    end

    def fetch(db)
      file = "#{PostalCode::DATA_PATH}/#{db}"
      return if File.file?(file)

      req = "#{PostalCode::WOF_PATH}/wof-dist-fetch-darwin " \
      '-inventory https://dist.whosonfirst.org/sqlite/inventory.json ' \
      "-dest #{PostalCode::DATA_PATH} " \
      "-include '#{db}'"
      system(req)
    end

    def convert_to_csv(db)
      file = "#{PostalCode::DATA_PATH}/#{db}"
      return unless File.file?(file)

      cmd = "#{PostalCode::WOF_PATH}/convert-db-to-csv.sh " \
      "#{PostalCode::DATA_PATH}/#{db}"
      system(cmd)

      csv_dir = csv_data_dir(db)
      system("mkdir -p #{csv_dir}")
      system("mv #{PostalCode::ROOT_PATH}/*.csv #{csv_dir}")
    end

    def db_type(type)
      "whosonfirst-data-#{type}-#{@country}-latest.db"
    end

    def csv_data_dir(db)
      "#{PostalCode::DATA_PATH}/#{extract_type(db)}"
    end

    def extract_type(db_str)
      db_str.gsub('whosonfirst-data-', '').gsub("-#{@country}-latest.db", '')
    end
  end
end
