# frozen_string_literal: true

ruby "3.2.2"
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "sinatra"
gem "sinatra-contrib", require: false

gem "activesupport"
gem "http"
gem "puma"
gem "redis"

gem "newrelic_rpm"

group :development do
  gem "citizens-advice-style", github: "citizensadvice/citizens-advice-style-ruby", tag: "v10.0.1"
  gem "debug"
  gem "rack-test"
  gem "rspec"
  gem "webmock"
end
