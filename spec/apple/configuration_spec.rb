require 'spec_helper'

describe AppleNewsClient::Configuration do

  let(:attributes) do
    {
      channel_id:     '12345',
      api_key_id:     'testkey',
      api_key_secret: 'dGVzdHNlY3JldA=='
    }
  end

  it 'can be created via an attributes hash' do
    config = AppleNewsClient::Configuration.new(attributes)
    expect(config.channel_id).to eq('12345')
  end

  it 'has a default value for api_base' do
    config = AppleNewsClient::Configuration.new(attributes)
    expect(config.api_base).to eq('https://news-api.apple.com')
  end

  it 'returns the configured channel' do
    allow_any_instance_of(AppleNewsClient::Channel).to receive(:fetch_data).and_return('data' => {})
    config = AppleNewsClient::Configuration.new(attributes)
    expect(config.channel.id).to eq('12345')
  end

end
