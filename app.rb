# frozen_string_literal: true

require "sinatra"
require "newrelic_rpm"
require "active_support/core_ext/object"
require "active_support/core_ext/string"

require_relative "lib/mock_mode"
require_relative "lib/cache"
require_relative "lib/query"
require_relative "lib/mock_query"
require_relative "lib/http_error"

configure { set :server, :puma }

puts "Starting in MOCK_MODE" if MockMode.enabled?

if Sinatra::Base.development?
  require "sinatra/reloader"
  require "debug"
  enable :reloader

  get "/flush" do
    Cache.flush
  end
end

get "/addresses/:postcode" do
  halt 200, { "Content-Type" => "application/json" }, MockQuery.new(params).response if MockMode.enabled?

  content_type query.options[:format].presence_in(%w[json xml]) || "json"
  (params[:refresh] == "true" ? nil : Cache.get(key)) || Cache.set(key, value)
end

get "/status" do
  halt 200 if MockMode.enabled?

  Cache.get("_") # Test if Redis is connecting
  200
end

private

def valid_key?
  params[:api_key] == Query::API_KEY
end

def key
  "#{query.postcode}/#{query.options}"
end

def value
  raise HTTPError, query_response unless query_response.status.success?

  query_response.body.to_s
end

def query_response
  @query_response ||= query.response
end

def query
  @query ||= Query.new(params)
end

# Forbidden
error 403 do
  content_type "text/plain"
  "Incorrect Search Key (check Status service for additional details)"
end

error HTTPError do
  NewRelic::Agent.notice_error(env["sinatra.error"])
  content_type "text/plain"
  env["sinatra.error"].message
end

error HTTP::TimeoutError do
  NewRelic::Agent.notice_error(env["sinatra.error"])
  504
end
