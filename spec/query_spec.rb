# frozen_string_literal: true

require_relative "../lib/query"

describe Query do
  it "defaults to json" do
    subject = described_class.new(postcode: "E1")
    expect(subject.options[:format]).to eq "json"
  end

  it "whitelist options" do
    subject = described_class.new(postcode: "E1", invalid: "option", page: "1")
    expect(subject.options).to eq("format" => "json", "page" => "1")
  end

  it "removes spaces from postcode" do
    subject = described_class.new(postcode: "E1      2EA")
    expect(subject.postcode).to eq "E1 2EA"
  end

  it "capitalize postcode" do
    subject = described_class.new(postcode: "e1 2ea")
    expect(subject.postcode).to eq "E1 2EA"
  end

  it "fetches endpoint" do
    stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/E1?format=json")
      .to_return(status: 200, body: read_json("E1"))

    subject = described_class.new(postcode: "E1")
    expect(subject.response.to_s).to eq read_json("E1")
  end

  it "URI-escape endpoint" do
    stub_request(:get, "https://ws.postcoder.com/pcw/#{api_key}/address/uk/E1%202EA?format=json")
      .to_return(status: 200, body: read_json("E1"))

    subject = described_class.new(postcode: "E1 2EA")
    expect(subject.response.to_s).to eq read_json("E1")
  end
end
