# frozen_string_literal: true

require "debtective/boundaries"

module Debtective
  class Todos
    def initialize(file_path)
      @file_path = file_path
    end

    def call
      lines.filter_map.with_index do |line, index|
        next unless line.match?(/^\s*#\sTODO:\s/)

        [
          @file_path,
          *Boundaries.new(lines, index).call
        ]
      end
    end

    private

    def lines
      @lines ||= File.readlines(@file_path)
    end
  end
end
