# frozen_string_literal: true

namespace :wof do
  desc 'Download admin and postcode db for a [country]. jp, kr, etc'
  task :download_db, [:country] do |_, args|
    country = args[:country] || 'jp'
    target = PostCodes::WofImporter.new(country)
    target.download
  end
end
