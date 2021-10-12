# frozen_string_literal: true

require "redis"
require "active_support/core_ext/object"

class Cache
  OPTIONS = {
    timeout: 1,
    namespace: "postcoder",
    url: ENV.fetch("CACHE_URL"),
    ttl: ENV.fetch("CACHE_TTL").to_i
  }.freeze

  REDIS = Redis.new(OPTIONS)
  private_constant :REDIS

  class << self
    def get(key)
      REDIS.get expand_cache_key(key)
    end

    def set(key, value)
      REDIS.setex(expand_cache_key(key), OPTIONS[:ttl], value) if value.present?
      value
    end

    def flush
      REDIS.flushdb
    end

    private

    def expand_cache_key(key)
      "#{OPTIONS[:namespace]}/#{key}"
    end
  end
end