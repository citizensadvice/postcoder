# frozen_string_literal: true

class MockMode
  # Doing it this way makes the testing easier
  def self.enabled?
    ENV.fetch("MOCK_MODE", "false") == "true"
  end
end
