# frozen_string_literal: true

require "sinatra/indifferent_hash"

class Query
  attr_reader :postcode, :options

  def initialize(params)
    @postcode = params[:postcode]
    @options = Sinatra::IndifferentHash.new.merge(format: "json")
  end

  def response
    safe_file_name = postcode.downcase.gsub(/[^a-z0-9]/, "")
    body = File.binread(File.dirname(__FILE__) + "../mock_responses/#{safe_file_name}.json")
    @response ||= HTTP::Response.new(
      status: 200,
      body:
    )
  rescue Errno::ENOENT
    "[]"
  end
end
