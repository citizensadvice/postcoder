# frozen_string_literal: true

ruby file: ".ruby-version"
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "sinatra"
gem "sinatra-contrib", require: false

gem "activesupport"
gem "http"
gem "puma", "~> 8.0.2"
gem "rackup"
gem "redis"

gem "newrelic_rpm"

group :development do
  gem "citizens-advice-style", github: "citizensadvice/citizens-advice-style-ruby", tag: "v12.1.0"
  gem "debug"
  gem "rack-test"
  gem "rspec"
  gem "webmock"
end
