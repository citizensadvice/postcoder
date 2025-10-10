# frozen_string_literal: true

require "http"
require "sinatra/indifferent_hash"
require "active_support/core_ext/string"
require "addressable/template"
require_relative "query"

class FindQuery
  attr_reader :id, :search, :options

  # https://developers.alliescomputing.com/postcoder-web-api/address-lookup
  ALLOWABLE_OPTIONS = %i[format lines page include exclude callback alias addtags].freeze
  API_ORIGIN = "https://ws.postcoder.com"
  API_KEY = ENV.fetch("API_KEY", "PCW45-12345-12345-1234X")

  DEFAULT_OPTIONS = Sinatra::IndifferentHash.new.merge(format: "json")

  def initialize(params)
    @id = params[:id]
    @search = params[:search].squish.upcase
    @options = DEFAULT_OPTIONS.merge(params).slice(*ALLOWABLE_OPTIONS)
  end

  def response
    @response ||= HTTP.timeout(connect: 5, read: 5).get(endpoint, params: options)
  end

  private

  def endpoint
    Addressable::Template
      .new("#{API_ORIGIN}/pcw/autocomplete/find?#{search_filter}&country=uk&apikey=#{API_KEY}")
      .expand(id:, search:)
      .to_s
  end

  # See https://postcoder.com/docs/address-lookup/autocomplete-find
  # If the id is nil it will be for a simple search to the api.
  # These results can return a set of addresses or a list of individual addresses if the search is detailed enough.
  # If the user selects a group of addresses we then pass it a search query and id.
  # The postcoder api requires the encoded characters that make up the id.
  # A user can continue to pass an id of this subset until all results are type of 'ADD'
  # one of these results will be the final 'id' used to call the retrieve endpoint.
  def search_filter
    if id.nil?
      "query=#{search}"
    else
      "query=#{search}&pathfilter=#{id}"
    end
  end
end
