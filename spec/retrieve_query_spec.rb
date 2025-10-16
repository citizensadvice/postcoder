# frozen_string_literal: true

require_relative "../lib/retrieve_query"

describe RetrieveQuery do
  it "defaults to json" do
    subject = described_class.new(query: "E1")
    expect(subject.options[:format]).to eq "json"
  end

  it "whitelist options" do
    subject = described_class.new(query: "WA129EF", id: "1234567", invalid: "option", page: "1")
    expect(subject.options).to eq("format" => "json", "page" => "1", "apikey" => api_key, "country" => "uk", "id" => "1234567",
                                  "query" => "WA129EF")
  end

  it "fetches endpoint" do
    stub_request(:get, "https://ws.postcoder.com/pcw/autocomplete/retrieve/?apikey=PCW45-12345-12345-1234X&country=uk&format=json&id=26186107&query=WA129EF")
      .to_return(status: 200, body: read_json("WA129EF"))

    subject = described_class.new(query: "WA129EF", id: "26186107")
    puts subject.options
    expect(subject.response.to_s).to eq read_json("WA129EF")
  end
end
