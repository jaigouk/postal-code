# frozen_string_literal: true

require 'spec_helper'

describe PostCodes::WofImporter do
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

  describe '#export_to_csv' do
    context('basic features') do
      it 'migrate sqlite db to postgres' do
        ENV['DATABASE_NAME']='post_codes_test'
        allow(Kernel).to receive(:system).and_return(true)
        admin_db = 'whosonfirst-data-admin-jp-latest.db'
        post_db = 'whosonfirst-data-postalcode-jp-latest.db'

        expect(subject).to receive(:convert_to_csv).with(admin_db)
        expect(subject).to receive(:convert_to_csv).with(post_db)
        subject.export_to_csv
      end
    end
    context('administrative data') do
      it 'extracts geojson type - polygon or pint'
      it 'extracts properties like geom data'
      it 'extracts wof heirachy'
    end
    context('post code data') do
      it 'validates after importing data'
      it 'saves missing parent regions'
    end
  end
end