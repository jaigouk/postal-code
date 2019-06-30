# frozen_string_literal: true

require 'spec_helper'

describe PostalCode::Tile38 do
  before do
    PostalCode::Tile38.redis.del('fleet', 'bus0')
    PostalCode::Tile38.redis.del('fleet', 'bus1')
    PostalCode::Tile38.redis.del('fleet', 'bus2')
    PostalCode::Tile38.redis.del('fleet', 'bus3')
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

  describe '#redis' do
    it '' do

    end
  end

  describe '#redis' do
    it '' do

    end
  end
end