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
      expect(subject).to receive(:fetch).with('whosonfirst-data-admin-jp-latest.db')
      expect(subject).to receive(:fetch).with('whosonfirst-data-postalcode-jp-latest.db')
      subject.download
    end
  end

  describe '#import_one_repo' do
    context('basic features') do
      it 'checks repo exists'

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