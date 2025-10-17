# frozen_string_literal: true

class MockRetrieveQuery
  def initialize(params)
    @id = params[:id]
    @query = params[:query].downcase.gsub(/[^a-z0-9]/, "")
  end

  def response
    File.binread("mock_responses/retrieve/#{@id}-#{@query}.json")
  rescue Errno::ENOENT
    "[]"
  end
end
