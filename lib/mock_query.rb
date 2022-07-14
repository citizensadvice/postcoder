# frozen_string_literal: true

class MockQuery
  def initialize(params)
    @postcode = params[:postcode]
  end

  def response
    safe_file_name = @postcode.downcase.gsub(/[^a-z0-9]/, "")
    File.binread("mock_responses/#{safe_file_name}.json")
  rescue Errno::ENOENT
    "[]"
  end
end
