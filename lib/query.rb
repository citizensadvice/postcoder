# frozen_string_literal: true

require "http"
require "sinatra/indifferent_hash"
require "active_support/core_ext/string"
require "addressable/template"

class Query
  attr_reader :postcode, :options

  # https://developers.alliescomputing.com/postcoder-web-api/address-lookup
  ALLOWABLE_OPTIONS = %i[format lines page include exclude callback alias addtags].freeze
  API_ORIGIN = "https://ws.postcoder.com"
  API_KEY = ENV.fetch("API_KEY")

  DEFAULT_OPTIONS = Sinatra::IndifferentHash.new.merge(format: "json")
  TIMEOUT_RESPONSE = HTTP::Response.new(status: 504, version: "1.1", connection: nil)

  def initialize(params)
    @postcode = params[:postcode].squish.upcase
    @options = DEFAULT_OPTIONS.merge(params).slice(*ALLOWABLE_OPTIONS)
  end

  def response
    @response ||=
      HTTP
      .timeout(connect: 5, read: 5)
      .get(endpoint, params: options)
  rescue HTTP::TimeoutError
    TIMEOUT_RESPONSE
  end

  private

  def endpoint
    Addressable::Template
      .new("#{API_ORIGIN}/pcw/#{API_KEY}/address/uk/{postcode}")
      .expand(postcode: postcode)
      .to_s
  end
end