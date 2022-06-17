# frozen_string_literal: true

require_relative "../app"

describe Sinatra::Application do
  describe "status" do
    it "returns 200 status" do
      get "/status"
      expect(last_response).to be_ok
    end
  end

  describe "postcoder proxy" do
    let(:endpoint) { "/pcw/#{api_key}/address/uk/E1" }

    it "returns JSON as default" do
      get endpoint
      expect(last_response).to be_ok
      expect(last_response.headers["Content-Type"]).to include "json"
    end

    it "returns XML" do
      get "#{endpoint}?format=xml"
      expect(last_response).to be_ok
      expect(last_response.headers["Content-Type"]).to include "xml"
    end

    it "returns body" do
      Cache.flush
      get endpoint
      expect(last_response.body).to eq read_json("E1")
    end

    it "returns 403 if invalid key" do
      get "/pcw/INVALID-KEY/address/uk/E1"
      expect(last_response).to be_forbidden
    end

    it "returns 504 if timeout" do
      get "/pcw/#{api_key}/address/uk/T1"
      expect(last_response.status).to eq 504
    end
  end

  describe "caching" do
    let(:endpoint) { "/pcw/#{api_key}/address/uk/E1" }

    it "removes invalid keys from cache key" do
      expect(Cache).to receive(:get).with('E1/{"format"=>"xml", "lines"=>"1"}')
      get "#{endpoint}?format=xml&lines=1&invalid=key"
    end

    it "formats postcode" do
      # normal
      expect(Cache).to receive(:get).with('E1 3AH/{"format"=>"json"}')
      get "/pcw/#{api_key}/address/uk/E1%203AH"
      # multiple spaces
      expect(Cache).to receive(:get).with('E1 3AH/{"format"=>"json"}')
      get "/pcw/#{api_key}/address/uk/E1%20%20%203AH%20"
      # lower case
      expect(Cache).to receive(:get).with('E1 3AH/{"format"=>"json"}')
      get "/pcw/#{api_key}/address/uk/e1%203ah"
    end

    it "does not set cache if previously called" do
      get endpoint
      expect(Cache).not_to receive(:set)
      get endpoint
    end

    it "sets cache if new key" do
      expect(Cache).to receive(:get).once.with('N2/{"format"=>"json"}')
      expect(Cache).to receive(:set).once
      get "/pcw/#{api_key}/address/uk/N2"
    end
  end
end
