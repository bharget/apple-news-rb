require 'spec_helper'

describe AppleNewsClient::Request::Delete do

  it 'builds the url from the config' do
    config  = AppleNewsClient::Configuration.new(api_base: 'https://api.foo.com')
    request = AppleNewsClient::Request::Delete.new('/somepath', config)
    expect(request.url.to_s).to eq('https://api.foo.com/somepath')
  end

end
