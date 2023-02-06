# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "pry"
require "debtective"

Debtective.configure do |config|
  config.paths = ["spec/dummy/app/**/*"]
end
