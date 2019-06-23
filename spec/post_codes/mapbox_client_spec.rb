# frozen_string_literal: true

require 'spec_helper'

describe PostCodes::MapboxClient do
  it 'respons' do
    client = PostCodes::MapboxClient.new('get', 'https://google.com', {})

    expect(client.nil?).to be_falsey
  end
end
