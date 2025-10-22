# frozen_string_literal: true

class MockFindQuery
  def initialize(params)
    @postcode = params[:query]
  end

  def response
    safe_file_name = @postcode.downcase.gsub(/[^a-z0-9]/, "")
    File.binread("mock_responses/find/#{safe_file_name}.json")
  rescue Errno::ENOENT
    "[]"
  end
end
