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

  describe '#import_wof_csv' do
    it 'returns nil if there is no matching directory' do
      allow(File).to receive(:directory?).and_return(false)
      expect(subject).to receive(:read_csv_and_save).with('admin')
      expect(subject).to receive(:read_csv_and_save).with('postalcode')
      subject.import_wof_csv
    end

    it 'returns nil if there is no match csv file' do
      allow(File).to receive(:directory?).and_return(true)
      allow(File).to receive(:file?).and_return(true)
      expect(subject).to receive(:read_csv_and_save).with('admin')
      expect(subject).to receive(:read_csv_and_save).with('postalcode')
      subject.import_wof_csv
    end
  end

  describe '#x' do
    # context('administrative data') do
    #   it 'extracts geojson type - polygon or pint'
    #   it 'extracts properties like geom data'
    #   it 'extracts wof heirachy' do
    #     # add extra migration file for this
    #   end
    # end
    # context('post code data') do
    #   it 'validates after importing data'
    #   it 'saves missing parent regions'
    # end
  end
end