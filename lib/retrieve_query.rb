# frozen_string_literal: true

require "http"
require "sinatra/indifferent_hash"
require "active_support/core_ext/string"
require "addressable/template"
require_relative "query"

class RetrieveQuery
  attr_reader :query, :id, :options

  # https://developers.alliescomputing.com/postcoder-web-api/address-lookup
  ALLOWABLE_OPTIONS = %i[id country query apikey format lines page include exclude callback alias addtags].freeze
  API_ORIGIN = "https://ws.postcoder.com"
  API_KEY = ENV.fetch("API_KEY", "PCW45-12345-12345-1234X")

  DEFAULT_OPTIONS = Sinatra::IndifferentHash.new.merge(format: "json", country: "uk", apikey: API_KEY)

  def initialize(params)
    @options = DEFAULT_OPTIONS.merge(params).slice(*ALLOWABLE_OPTIONS)
  end

  def response
    @response ||= HTTP.timeout(connect: 5, read: 5).get(endpoint, params: options)
  end

  private

  # https://postcoder.com/docs/address-lookup/autocomplete-retrieve
  # The retrieve endpoint requires an id and the search term used.
  # The id will be of a type 'ADD' that has been returned in the find query.
  def endpoint
    Addressable::Template
      .new("#{API_ORIGIN}/pcw/autocomplete/retrieve/?")
      .expand(query:, id:)
      .to_s
  end
end
