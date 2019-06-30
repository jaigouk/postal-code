# frozen_string_literal: true

require 'spec_helper'

describe PostalCode::WofImporter do
  subject do
    described_class.new('jp')
  end

  describe '#download_db_for_country' do
    it 'downloads administrative and postcode data for 1 country' do
      allow(File).to receive(:file?).and_return(false)
      allow(Kernel).to receive(:system).and_return(true)
      admin_db = 'whosonfirst-data-admin-jp-latest.db'
      post_db = 'whosonfirst-data-postalcode-jp-latest.db'

      expect(subject).to receive(:fetch).with(admin_db)
      expect(subject).to receive(:fetch).with(post_db)
      subject.download
    end
  end

  describe '#export_wof_to_csv' do
    it 'migrate sqlite db to postgres' do
      ENV['DATABASE_NAME']='postal_code_test'
      allow(Kernel).to receive(:system).and_return(true)
      admin_db = 'whosonfirst-data-admin-jp-latest.db'
      post_db = 'whosonfirst-data-postalcode-jp-latest.db'

      expect(subject).to receive(:convert_to_csv).with(admin_db)
      expect(subject).to receive(:convert_to_csv).with(post_db)
      subject.export_wof_to_csv
    end
  end

  describe '#save_csv_to_db' do
   it 'x' do
    %w[ancestor concordance name geojson spr].each do |k|
      klass = "PostalCode::#{k.capitalize}".constantize
      allow(klass).to receive(:import).and_return(true)
    end
    expect(subject).to receive(:import_csv).with('admin')
    expect(subject).to receive(:import_csv).with('postalcode')
    subject.save_csv_to_db
   end
  end
end