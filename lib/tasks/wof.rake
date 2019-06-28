# frozen_string_literal: true

namespace :wof do
  desc 'Download admin and postcode db for a [country] (For example, jp, kr)'
  task :download_db, [:country] => :environment do |_, args|
    country = args[:country] || 'jp'
    target = PostCodes::WofImporter.new(country)
    target.download
  end

  desc 'Convert sqlite db into csv for a given [country] (For example, jp, kr)'
  task :convert_to_csv, [:country] => :environment do |_, args|
    country = args[:country] || 'jp'
    target = PostCodes::WofImporter.new(country)
    target.export_to_csv
  end
end
