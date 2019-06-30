# frozen_string_literal: true

namespace :wof do
  desc 'Download admin and postcode db for a [country] (For example, jp, kr)'
  task :download_db, [:country] => :environment do |_, args|
    country = args[:country] || 'jp'
    target = PostalCode::WofImporter.new(country)
    target.download
  end

  desc 'Convert sqlite db into csv for a given [country] (For example, jp, kr)'
  task :convert_to_csv, [:country] => :environment do |_, args|
    country = args[:country] || 'jp'
    target = PostalCode::WofImporter.new(country)
    target.export_wof_to_csv
    target.change_csv_haders
  end

  desc 'Save csv files to postgresql db'
  task :import_csv_to_db, [:country] => :environment do |_, args|
    country = args[:country] || 'jp'
    target = PostalCode::WofImporter.new(country)
    target.import_csv_to_db
  end
end
