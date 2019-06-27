# frozen_string_literal: true

require 'spec_helper'

describe PostCodes::Geocoding do
  subject do
    lat = 52.494857
    lon = 13.437641
    PostCodes::Geocoding.new(lon, lat, 'museums')
  end

  describe '#country_code', :vcr do
    it 'contains country code based on the coordinates' do
      res = subject.country_code
      expect(res).to include('de')
    end

    it 'returns nil if the coordinates are wrong' do
      lat = 2.497
      lon = 100_000.437641
      res = described_class.new(lon, lat, 'museums').country_code
      expect(res).to be_falsey
    end
  end

  describe '#self.group_by_postcodes' do
    it 'groups mapbox search results with postcodes' do
      fixture = File.join(__dir__, '..', 'fixtures', 'museums_in_germany.yml')
      data = YAML.load_file(fixture)
      res = described_class.group_by_postcode(data)
      expect(res['10963'].size).to eq 2
      expect(res['12627'].size).to eq 1
      expect(res['14195'].size).to eq 1
      expect(res['12627'].size).to eq 1
    end
  end

  describe '#respond', :vcr do
    it 'returns grouped hash' do
      res = subject.respond
      expect(res).not_to be_falsey
      expect(res.class.name).to eq('Hash')
      expect(res['10963'].size).to eq 2
      expect(res['10785'].size).to eq 1
      expect(res['12627'].size).to eq 1
      expect(res['15562'].size).to eq 1
    end

    it 'always returns post codes even though mapbox does not have it', :vcr do
      lat=35.7020691
      lon=139.7753269
      res = described_class.new(lon, lat, 'starbucks').respond
      #save_fixture('starbucks_japan',res )
    end
  end
end
