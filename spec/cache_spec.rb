# frozen_string_literal: true

require "newrelic_rpm"
require_relative "../lib/cache"

describe Cache do
  let(:redis) { described_class.const_get("REDIS") }

  describe ".get" do
    it "retrieves the cache" do
      allow(redis).to receive(:get).with("/key").and_return("value")
      expect(described_class.get("key")).to eq "value"
    end

    it "is resilient to cannot connect errors" do
      allow(NewRelic::Agent).to receive(:notice_error)
      allow(redis).to receive(:get).and_raise(Redis::CannotConnectError)
      expect(described_class.get("key")).to be_nil
      expect(NewRelic::Agent).to have_received(:notice_error).with(a_kind_of(Redis::CannotConnectError))
    end
  end

  describe ".set" do
    it "caches if value present" do
      allow(redis).to receive(:setex)
      described_class.set("key", "value")
      expect(redis).to have_received(:setex)
    end

    it "does not caches if value blank" do
      allow(redis).to receive(:setex)
      described_class.set("key", "")
      expect(redis).not_to have_received(:setex)
    end

    it "does not caches if value nil" do
      allow(redis).to receive(:setex)
      described_class.set("key", nil)
      expect(redis).not_to have_received(:setex)
    end

    it "is resilient to cannot connect errors" do
      allow(NewRelic::Agent).to receive(:notice_error)
      allow(redis).to receive(:setex).and_raise(Redis::CannotConnectError)
      expect(described_class.set("key", "value")).to eq "value"
      expect(NewRelic::Agent).to have_received(:notice_error).with(a_kind_of(Redis::CannotConnectError))
    end
  end
end
