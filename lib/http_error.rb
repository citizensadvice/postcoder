# frozen_string_literal: true

class HTTPError < StandardError
  def initialize(response)
    super "response error: #{response.status}: #{response.body}"
  end
end
