# frozen_string_literal: true

module Queries
  class Postcode
    # https://developers.alliescomputing.com/postcoder-web-api/address-lookup
    ALLOWABLE_OPTIONS = %i[format lines page include exclude callback alias addtags].freeze
    API_ORIGIN = "https://ws.postcoder.com"
    API_KEY = ENV.fetch("API_KEY", "PCW45-12345-12345-1234X")

    DEFAULT_OPTIONS = Sinatra::IndifferentHash.new.merge(format: "json")

    def initialize(params)
      @postcode = params[:postcode].squish.upcase
      @options = DEFAULT_OPTIONS.merge(params).slice(*ALLOWABLE_OPTIONS)
    end

    def response
      @response ||= HTTP.timeout(connect: 5, read: 5).get(endpoint, params: options)
    end

    private

    def endpoint
      Addressable::Template
        .new("#{API_ORIGIN}/pcw/#{API_KEY}/address/uk/{postcode}")
        .expand(postcode:)
        .to_s
    end
  end
end
