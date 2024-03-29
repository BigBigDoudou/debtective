# frozen_string_literal: true

require "pry"

require "simplecov"
SimpleCov.start do
  add_filter "spec"
end

require "debtective"
(Dir["lib/**/*.rb"] - ["lib/debtective/railtie.rb"]).each { require_relative "../#{_1}" }
