# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/config/"
  add_filter "/test/"
end
