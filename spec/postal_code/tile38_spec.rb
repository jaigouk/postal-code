# frozen_string_literal: true

require 'spec_helper'

describe PostalCode::Tile38 do
  before do
    PostalCode::Tile38.redis.del('fleet', 'bus0')
    PostalCode::Tile38.redis.del('fleet', 'bus1')
    PostalCode::Tile38.redis.del('fleet', 'bus2')
    PostalCode::Tile38.redis.del('fleet', 'bus3')
    PostalCode::Tile38.redis.del('postalcode', '538425831')
    PostalCode::Tile38.redis.del('region', '85672871')
    PostalCode::Tile38.redis.del('neighbourhood', '85911073')
    PostalCode::Tile38.redis.del('region', '85672769')
    PostalCode::Tile38.redis.del('county', '890524505')
    PostalCode::Tile38.redis.del('locality', '1344243079')
    PostalCode::Tile38.redis.del('neighbourhood', '85935557')
    PostalCode::Tile38.redis.del('neighbourhood', '1126075403')
  end

  describe '#redis' do
    it 'returns redis client' do
      version = PostalCode::Tile38.redis.info['redis_version']
      expect(version).not_to be_falsey
    end
  end

  describe '#namespace' do
    it 'returns namespace' do
      namespace = PostalCode::Tile38.namespace
      expect(namespace).to eq('tile38')
    end
  end

  describe '#namespaced_key' do
    it 'returns keys with default namespace' do
      keys = PostalCode::Tile38.namespaced_key('hello', 'there')
      expect(keys).to eq('tile38:hello:there')
    end
  end

  describe '#set' do
    it 'returns error for wrong arguments' do
      res = PostalCode::Tile38.set('mini', 'mac')
      expect(res[:error]).to include('wrong number of arguments')
    end

    it 'returns json for a proper arguments' do
      res = PostalCode::Tile38.set('fleet', 'bus0', 'POINT', '33.5123', '-112.269')
      expect(res[:success]).to be_truthy
    end
  end

  describe '#get' do
    it 'returns nil for number of wrong arguemts' do
      PostalCode::Tile38.set('fleet', 'bus1', 'POINT', '33.5123', '-112.269')
      res = PostalCode::Tile38.get('fleet', 'bus1' 'POINT')
      expect(res).to eq({:error=>"not_found"})
    end

    it 'returns data' do
      PostalCode::Tile38.set('fleet', 'bus2', 'POINT', '33.5123', '-112.269')
      res = PostalCode::Tile38.get('fleet', 'bus2')
      expect(res['type']).to eq('Point')
      expect(res['coordinates']).to eq([-112.269, 33.5123])
    end

    it 'returns not_found message' do
      PostalCode::Tile38.set('fleet', 'bus3', 'POINT', '33.5123', '-112.269')
      res = PostalCode::Tile38.get('fleet', 'car')
      expect(res).to eq({:error=>"not_found"})
    end
  end

  describe '#insert_geojson' do
    let(:point) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/point.json") }
    let(:polygon) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/polygon.json") }
    let(:multi_polygon) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/multi_polygon.json") }

    context 'point' do
      it 'inserts point geojson and properties' do
        PostalCode::Tile38.insert_geojson(namespace: 'postalcode', key: '538425831', geojson: point)
        got = PostalCode::Tile38.get('postalcode', '538425831')
        hierarchy =[{"continent_id" => "102191569",
                     "country_id" => "85632429",
                     "locality_id" => 102031667,
                     "postalcode_id" => 538425831,
                     "region_id" => 85672769}]

        expect(got['type']).to eq('Feature')
        expect(got['properties']['wof:hierarchy']).to eq(hierarchy)
        expect(got['id']).to eq(538425831)
        expect(got['geometry']['type']).to eq('Point')
        expect(got['geometry']['coordinates'].size).to eq 2
      end
    end

    context 'polygon' do
      it 'inserts polygon geojson and properties' do
        PostalCode::Tile38.insert_geojson(namespace: 'region', key: '85672871', geojson: polygon)
        got = PostalCode::Tile38.get('region', '85672871')
        hierarchy = [{"continent_id"=>102191569, "country_id"=>85632429, "region_id"=>85672871}]

        expect(got['type']).to eq('Feature')
        expect(got['properties']['wof:hierarchy']).to eq(hierarchy)
        expect(got['id']).to eq(85672871)
        expect(got['geometry']['type']).to eq('Polygon')
        expect(got['geometry']['coordinates'].size).to eq 1
      end
    end

    context 'multi_polygon' do
      it 'inserts polygon geojson and properties' do
        PostalCode::Tile38.insert_geojson(namespace: 'neighbourhood', key: '85911073', geojson: multi_polygon)
        got = PostalCode::Tile38.get('neighbourhood', '85911073')
        hierarchy =  [{"continent_id"=>102191569,
                       "country_id"=>85632429,
                       "county_id"=>1108741697,
                       "locality_id"=>102031379,
                       "neighbourhood_id"=>85911073,
                       "region_id"=>85672817}]

        expect(got['type']).to eq('Feature')
        expect(got['properties']['wof:hierarchy']).to eq(hierarchy)
        expect(got['id']).to eq(85911073)
        expect(got['geometry']['type']).to eq('MultiPolygon')
        expect(got['geometry']['coordinates'].size).to eq 2
      end
    end
  end

  describe '#find_postal_code' do
    let(:region) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/1_region_85672769.geojson") }
    let(:county) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/2_county_890524505.geojson") }
    let(:locality) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/3_locality_1344243079.geojson") }
    let(:neighbourhood1) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/4_neighbourhood_85935557.geojson") }
    let(:neighbourhood2) { File.read("#{PostalCode::ROOT_PATH}/spec/fixtures/5_neighbourhood_1126075403.geojson") }

    before do
      PostalCode::Tile38.insert_geojson(namespace: 'region', key: '85672769', geojson: region)
      PostalCode::Tile38.insert_geojson(namespace: 'county', key: '890524505', geojson: county)
      PostalCode::Tile38.insert_geojson(namespace: 'locality', key: '1344243079', geojson: locality)
      PostalCode::Tile38.insert_geojson(namespace: 'neighbourhood', key: '85935557', geojson: neighbourhood1)
      PostalCode::Tile38.insert_geojson(namespace: 'neighbourhood', key: '1126075403', geojson: neighbourhood2)
    end

    context('locality') do
      it 'returns not found if there is no matching' do
        got = PostalCode::Tile38.nearby(key: 'region', lat: 34.6658157, lon: 134.9583232)
        expect(got).to eq({:error=>"not_found"})
      end

      it 'searches namespace with coordinates.' do
        # 2-chōme-6-2 西明石西町１丁目 Akashi-shi, Hyōgo-ken 673-0049, Japan
        # 〒673-0049 兵庫県明石市西明石西町１丁目２丁目６−2
        # https://www.google.com/maps/place/%E3%81%A1%E3%82%8D%E3%82%8A%E3%82%93%E6%9D%91/@34.6658157,134.9583232,20.89z/data=!4m13!1m7!3m6!1s0x0:0x0!2zMzTCsDM5JzU3LjAiTiAxMzTCsDU3JzMwLjIiRQ!3b1!8m2!3d34.6658198!4d134.9583807!3m4!1s0x3554d46085531783:0x770e780916a7cc16!8m2!3d34.6658807!4d134.9583185
        # lat,lon = 34.6658157,134.9583232
        # name = ちろりん村 (a pet store)

        # 2 results. 2 km range
        # PostalCode::Tile38.redis.call([:nearby, 'neighbourhood', 'POINT', "34.6658157", "134.9583232", "2000"])

        # From 1126075403 to the petstore takes 17min. 1.3km walking distance
        # https://www.google.ae/maps/dir/'34.6658157,134.9583232'/34.674088,134.951472/@34.6699524,134.9503895,16z/data=!3m1!4b1!4m7!4m6!1m3!2m2!1d134.9583232!2d34.6658157!1m0!3e2

        # Frome 85935557 to the petstore 1.3km. 16min walking distance.
        # https://www.google.ae/maps/dir/'34.666196,134.958252'/34.674088,134.951472/@34.6701418,134.9503895,16z/data=!3m1!4b1!4m7!4m6!1m3!2m2!1d134.958252!2d34.666196!1m0!3e2
        # 1.3
        got = PostalCode::Tile38.nearby(key: 'neighbourhood', lat: 34.6658157, lon: 134.9583232)
        hierarchy = [{"continent_id"=>102191569,
                      "country_id"=>85632429,
                      "county_id"=>890524505,
                      "locality_id"=>-1,
                      "neighbourhood_id"=>85935557,
                      "region_id"=>85672769}]

        expect(got['type']).to eq('Feature')
        expect(got['properties']['wof:hierarchy']).to eq(hierarchy)
        expect(got['id']).to eq(85935557)
        expect(got['geometry']['type']).to eq('Point')
        expect(got['geometry']['coordinates'].size).to eq 2
      end
    end
  end
end
