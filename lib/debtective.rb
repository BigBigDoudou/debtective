# frozen_string_literal: true

require "debtective/version"
require "debtective/configuration"

# Entrypoint
module Debtective
  class << self
    attr_accessor :configuration

    # Configures Debtective
    # @return Debtective::Configuration
    # @yieldparam [Proc] configuration to apply
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end
