# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "spec"
end

require "debtective"
(Dir["lib/**/*.rb"] - ["lib/debtective/railtie.rb"]).each { require_relative "../#{_1}" }

Debtective.configure do |config|
  config.paths = ["spec/dummy/app/**/*"]
end
