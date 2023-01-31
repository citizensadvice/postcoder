# frozen_string_literal: true

ENV["APP_ENV"] = "test"

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
    ENV.fetch("API_KEY", "PCW45-12345-12345-1234X")
  end

  def read_json(filename)
    File.read("#{File.dirname(__FILE__)}/fixtures/#{filename}.json")
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.before do
    # Prevent the logger spamming the logs
    stub_const("LOGGER", Logger.new(IO::NULL))
  end
end
