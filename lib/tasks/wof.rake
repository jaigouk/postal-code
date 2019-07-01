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

  # desc 'header'
  # task :header, [:country] => :environment do |_, args|
  #   country = args[:country] || 'jp'
  #   target = PostalCode::WofImporter.new(country)
  #   target.change_csv_haders
  # end

  desc 'Save csv files to postgresql db'
  task :import_csv_to_db, [:country] => :environment do |_, args|
    country = args[:country] || 'jp'
    target = PostalCode::WofImporter.new(country)
    target.import_csv_to_db
  end

  # It took 149.771128 to finish this task for 199558 records.
  #
  # TODO:
  # 1. filter country code
  # country = args[:country].blank? ? 'JP' : args[:country].upcase
  # 2. async
  #
  desc 'Import geojson into tile38-server'
  task :import_geojson_to_tile38, [:country] => :environment do |_, args|
    start = Time.now
    target = PostalCode::Geojson.all
    target.each do |geo|
      wof_id = geo.wof_id
      namespace = PostalCode::Spr.where(wof_id: wof_id).first&.placetype
      PostalCode::Tile38.insert_geojson(namespace: namespace, key: wof_id, geojson: geo.body)
    end
    finish = Time.now
    puts("It took #{finish - start} to finish this task for #{target.size} records.")
  end

  task setup: %i[download_db convert_to_csv import_csv_to_db import_geojson_to_tile38]
end
