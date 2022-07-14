# frozen_string_literal: true

class Cache
  class << self
    def get(_); end

    def set(_, value)
      value
    end

    def flush; end
  end
end
