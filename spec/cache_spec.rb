# frozen_string_literal: true

require_relative "../lib/cache"

describe Cache do
  let(:redis) { described_class.const_get("REDIS") }

  describe ".get" do
    it "retrieves the cache" do
      allow(redis).to receive(:get).with("postcoder/key").and_return("value")
      expect(described_class.get("key")).to eq "value"
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
  end
end
