# frozen_string_literal: true

require_relative "../lib/cache"

describe "Cache" do
  let(:redis) { Cache.const_get("REDIS") }

  describe ".get" do
    it "retrieves the cache" do
      allow(redis).to receive(:get).with("postcoder/key").and_return("value")
      expect(Cache.get("key")).to eq "value"
    end
  end

  describe ".set" do
    it "caches if value present" do
      expect(redis).to receive(:setex)
      Cache.set("key", "value")
    end

    it "does not caches if value blank" do
      expect(redis).to_not receive(:setex)
      Cache.set("key", "")
    end

    it "does not caches if value nil" do
      expect(redis).to_not receive(:setex)
      Cache.set("key", nil)
    end
  end
end
