# frozen_string_literal: true

require_relative "../lib/query"

describe "Query" do
  it "defaults to json" do
    subject = Query.new(postcode: "E1")
    expect(subject.options[:format]).to eq "json"
  end

  it "whitelist options" do
    subject = Query.new(postcode: "E1", invalid: "option", page: "1")
    expect(subject.options).to eq("format" => "json", "page" => "1")
  end

  it "removes spaces from postcode" do
    subject = Query.new(postcode: "E1      2EA")
    expect(subject.postcode).to eq "E1 2EA"
  end

  it "capitalize postcode" do
    subject = Query.new(postcode: "e1 2ea")
    expect(subject.postcode).to eq "E1 2EA"
  end

  it "fetches endpoint" do
    subject = Query.new(postcode: "E1")
    expect(subject.response.to_s).to eq read_json("E1")
  end

  it "URI-escape endpoint" do
    subject = Query.new(postcode: "E1 2EA")
    expect(subject.send(:endpoint)).to eq "https://ws.postcoder.com/pcw/PCW45-12345-12345-1234X/address/uk/E1%202EA"
  end

  it "returns 504 response if timed out" do
    subject = Query.new(postcode: "T1")
    expect(subject.response.status).to_not be_success
    expect(subject.response.status).to eq 504
  end
end
