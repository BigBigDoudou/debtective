# frozen_string_literal: true

module Debtective
  # Manages gem configuration
  class Configuration
    attr_accessor :paths

    # Initializes the configuration
    # @return [Debtective::Configuration]
    def initialize
      @paths = []
    end
  end
end
