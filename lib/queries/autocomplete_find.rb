# frozen_string_literal: true

module Queries
  class AutocompleteFind
    # https://developers.alliescomputing.com/postcoder-web-api/address-lookup
    ALLOWABLE_OPTIONS = %i[query postcode pathfilter addtags singlesummary maximumresults enablefacets format].freeze
    API_ORIGIN = "https://ws.postcoder.com"
    API_KEY = ENV.fetch("API_KEY", "PCW45-12345-12345-1234X")

    DEFAULT_OPTIONS = Sinatra::IndifferentHash.new.merge(format: "json")

    def initialize(params)
      @postcode = params[:postcode].squish.upcase
      @options = DEFAULT_OPTIONS.merge(params).slice(*ALLOWABLE_OPTIONS)
    end

    def response
      @response ||= HTTP.timeout(connect: 5, read: 5).get(endpoint, params: options.merge(country: "uk", apikey: API_KEY))
    end

    private

    def endpoint
      Addressable::URI
        .parse("#{API_ORIGIN}/https://ws.postcoder.com/pcw/autocomplete/find")
        .to_s
    end
  end
end
