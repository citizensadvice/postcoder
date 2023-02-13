# frozen_string_literal: true

require_relative "../lib/version"

describe VERSION do
  it "matches the branch" do
    # Only really works locally. Just to enforce updating the branch
    branch = `git branch --show-current`.chomp
    expect(VERSION).to eq branch.sub(/^v/, "") if branch.match?(/^v?\d+\.\d+\.\d+/) # rubocop:disable RSpec/DescribedClass
  rescue Errno::ENOENT
    # ignore
  end
end
