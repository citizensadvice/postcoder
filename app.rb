# frozen_string_literal: true

require "sinatra"
require "newrelic_rpm"
require_relative "lib/cache"
require_relative "lib/query"

configure { set :server, :puma }

if ENV.fetch("APP_ENV", "development") != "production"
  require "sinatra/reloader"
  enable :reloader

  get "/flush" do
    Cache.flush
  end
end

# Deprecated
get "/pcw/:api_key/address/uk/:postcode" do
  valid_key? || halt(403)
  content_type query.options[:format]
  Cache.get(key) || Cache.set(key, value)
rescue HTTP::TimeoutError
  504
end

get "/addresses/:postcode" do
  content_type query.options[:format].presence_in(%w[json xml]) || "json"
  (params[:refresh] == "true" ? nil : Cache.get(key)) || Cache.set(key, value)
rescue HTTP::TimeoutError
  504
end

get "/status" do
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

# Gateway timeout
error 504 do
  "[]"
end
