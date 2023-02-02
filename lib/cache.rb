# frozen_string_literal: true

require "redis"
require_relative "application_logger"

class Cache
  OPTIONS = {
    connect_timeout: 0.3,
    url: ENV.fetch("CACHE_URL", "redis://localhost:6379")
  }.freeze
  TTL = ENV.fetch("CACHE_TTL", "86_400").to_i
  REDIS = MockMode.enabled? ? false : Redis.new(OPTIONS)
  private_constant :REDIS

  class << self
    def get(key)
      REDIS.get expand_cache_key(key)
    rescue Redis::CannotConnectError => e
      NewRelic::Agent.notice_error(e)
      LOGGER.error(e)
      nil
    end

    def set(key, value)
      REDIS.setex(expand_cache_key(key), TTL, value) if value.present?
      value
    rescue Redis::CannotConnectError => e
      NewRelic::Agent.notice_error(e)
      LOGGER.error(e)
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
