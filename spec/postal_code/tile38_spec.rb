# frozen_string_literal: true

require 'spec_helper'

describe PostalCode::Tile38 do
  before do
    PostalCode::Tile38.redis.del('fleet', 'bus0')
    PostalCode::Tile38.redis.del('fleet', 'bus1')
    PostalCode::Tile38.redis.del('fleet', 'bus2')
    PostalCode::Tile38.redis.del('fleet', 'bus3')
    PostalCode::Tile38.redis.del('japan', '538425831')
    PostalCode::Tile38.redis.del('japan', '85672871')
    PostalCode::Tile38.redis.del('japan', '85911073')
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
        PostalCode::Tile38.insert_geojson(namespace: 'japan', key: '538425831', geojson: point)
        got = PostalCode::Tile38.get('japan', '538425831')
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
        PostalCode::Tile38.insert_geojson(namespace: 'japan', key: '85672871', geojson: polygon)
        got = PostalCode::Tile38.get('japan', '85672871')
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
        PostalCode::Tile38.insert_geojson(namespace: 'japan', key: '85911073', geojson: multi_polygon)
        got = PostalCode::Tile38.get('japan', '85911073')
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

  # describe '#point_in_polygon' do
  #   context 'polygon' do
  #     it '' do

  #     end
  #   end

  #   context 'multi_polygon' do
  #     it '' do

  #     end
  #   end
  # end

  # describe '#polyons_for_point' do
  #   context 'polygon' do
  #     it '' do

  #     end
  #   end

  #   context 'multi_polygon' do
  #     it '' do

  #     end
  #   end
  # end

end