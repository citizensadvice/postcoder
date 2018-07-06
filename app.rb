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

get "/pcw/:api_key/address/uk/:postcode" do
  valid_key? || halt(403)
  content_type query.options[:format]
  Cache.get(key) || Cache.set(key, value)
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
  query.response.to_s
end

def query
  @query ||= Query.new(params)
end

error 403 do
  "Incorrect Search Key (check Status service for additional details)"
end
