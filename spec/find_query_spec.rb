# frozen_string_literal: true

require_relative "../lib/find_query"

describe FindQuery do
  it "defaults to json" do
    subject = described_class.new(query: "E1")
    expect(subject.options[:format]).to eq "json"
  end

  it "whitelist options" do
    subject = described_class.new(query: "E10", invalid: "option", page: "1")
    expect(subject.options).to eq("format" => "json", "page" => "1", "apikey" => api_key, "country" => "uk", "query" => "E10")
  end

  it "fetches endpoint" do
    stub_request(:get, "https://ws.postcoder.com/pcw/autocomplete/find?apikey=#{api_key}&country=uk&format=json&query=WA12")
      .to_return(status: 200, body: read_json("WA12"))

    subject = described_class.new(query: "WA12")
    expect(subject.response.to_s).to eq read_json("WA12")
  end

  it "URI-escape endpoint" do
    stub_request(:get, "https://ws.postcoder.com/pcw/autocomplete/find?apikey=#{api_key}&country=uk&format=json&query=WA12%209EW")
      .to_return(status: 200, body: read_json("WA12"))

    subject = described_class.new(query: "WA12 9EW")
    expect(subject.response.to_s).to eq read_json("WA12")
  end
end
