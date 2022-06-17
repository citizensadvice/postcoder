# frozen_string_literal: true

require "debug"
require "rack/test"
require "rspec"
require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def api_key
    ENV.fetch("API_KEY")
  end

  def read_json(filename)
    File.read("#{File.dirname(__FILE__)}/fixtures/#{filename}.json")
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before do
    stub_request(:any, /E1/).to_return(status: 200, body: read_json("E1"))
    stub_request(:any, /N2/).to_return(status: 200, body: read_json("N2"))
    stub_request(:any, /T1/).to_timeout
  end
end
