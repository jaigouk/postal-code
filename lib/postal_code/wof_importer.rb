# frozen_string_literal: true

require 'csv'
require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'

module PostalCode
  # WofImporter
  # downloads db and import it
  # ancestors csv id is for relationship.
  # same with names. multiple names
  class WofImporter
    ANCESTORS_HEADERS = %w[wof_id ancestor_wof_id ancestor_placetype
                           lastmodified].freeze
    CONCORDANCES_HEADERS = %w[wof_id other_id other_source lastmodified].freeze
    GEOJSON_HEADERS = %w[wof_id body lastmodified].freeze
    NAMES_HEADERS = %w[wof_id placetype country language extlang script region
                       variant extension privateuse name lastmodified].freeze
    SPR_HEADERS = %w[wof_id parent_id name placetype country repo latitude
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

    def change_csv_haders
      %w[admin postalcode].each { |t| update_csv_headers(t) }
    end

    def import_csv_to_db
      %w[admin postalcode].each { |t| import_csv(t) }
    end

    private

    def import_csv(type)
      TABLES.map { |x| "#{x}.csv" }.each do |t|
        file = "#{PostalCode::DATA_PATH}/#{type}/#{t}"
        data = []
        next unless File.file?(file)

        puts "importing #{t} into database"
        parsed_csv(file).each do |row|
          data << klass(t).new(row.to_h.select { |k, _| k.present? })
        end
        klass(t).import data
      end
    end

    def parsed_csv(file)
      CSV.parse(File.read(file).gsub("\r", ''), headers: true, col_sep: ',')
    end

    def update_csv_headers(type)
      return unless File.directory?(csv_data_dir(type))

      TABLES.map { |x| "#{x}.csv" }.each do |t|
        file = "#{PostalCode::DATA_PATH}/#{type}/#{t}"
        return nil unless File.file?(file)

        header = 'PostalCode::WofImporter::' \
        "#{t.gsub('.csv', '').upcase}_HEADERS"
        sed_cmd(header.constantize.join(','), file)
      end
    end

    def sed_cmd(headers, file)
      system("tmp=$(sed '1 s/^.*$/#{headers}/' #{file});" \
      " printf \"%s\" \"$tmp\" > #{file}")
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

    def klass(filename)
      sanitized = filename.gsub('.csv', '')
      if %w[ancestors concordances names].include?(sanitized)
        "PostalCode::#{sanitized.chomp('s').capitalize}".constantize
      else
        "PostalCode::#{sanitized.capitalize}".constantize
      end
    end
  end
end
