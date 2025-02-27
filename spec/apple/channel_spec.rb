require 'spec_helper'

describe AppleNewsClient::Channel do

  let(:fixture_data) do
    {
      'id'    => '111',
      'type'  => 'channel',
      'name'  => 'Test Channel',
      'links' => {
        'defaultSection' => 'https://news-api.apple.com/sections/4523e2f6'
      }
    }
  end

  context 'created with only an id' do
    let(:channel) { AppleNewsClient::Channel.new('111') }

    before do
      allow_any_instance_of(AppleNewsClient::Channel).to receive(:fetch_data).and_return('data' => fixture_data)
    end

    it 'will fetch attributes from the api' do
      expect(channel.type).to eq('channel')
      expect(channel.name).to eq('Test Channel')
    end

    it 'will use the default config' do
      expect(channel.config).to be(AppleNewsClient.config)
    end
  end

  context 'created with id and a data hash' do
    let(:channel) { AppleNewsClient::Channel.new('111', fixture_data) }

    it 'will set data attributes without fetching' do
      expect(channel.type).to eq('channel')
      expect(channel.name).to eq('Test Channel')
    end

    it 'will use the default config' do
      expect(channel.config).to be(AppleNewsClient.config)
    end
  end

  context 'created with id, data hash, and custom config' do
    let(:config) { AppleNewsClient::Configuration.new }
    let(:channel) { AppleNewsClient::Channel.new('111', fixture_data, config) }

    it 'will set data attributes without fetching' do
      expect(channel.type).to eq('channel')
      expect(channel.name).to eq('Test Channel')
    end

    it 'will use the custom config' do
      expect(channel.config).to be(config)
    end

    it 'will use the custom config when loading sections' do
      allow_any_instance_of(AppleNewsClient::Section).to receive(:fetch_data).and_return('data' => {})
      section = channel.default_section
      expect(section.config).to be(config)
    end

    it 'will load and hydrate articles' do
      allow_any_instance_of(AppleNewsClient::Article).to receive(:fetch_data).and_return('data' => {})
      expect(channel).to receive(:get_request).and_return(
        'data' => [{ 'id' => '123', 'type' => 'article', 'title' => 'Test Article' }]
      )
      article = channel.articles.first
      expect(article.id).to eq('123')
    end

    it 'will load articles without hydrating' do
      expect(channel).to receive(:get_request).and_return(
        'data' => [{ 'id' => '123', 'type' => 'article', 'title' => 'Test Article' }]
      )
      article = channel.articles(hydrate: false).first
      expect(article.id).to eq('123')
    end
  end

end
