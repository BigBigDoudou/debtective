# frozen_string_literal: true

module Debtective
  class Boundaries
    def initialize(lines, index)
      @lines = lines
      @index = index
    end

    def call
      [start_index + 1, end_index + 1]
    end

    private

    def start_index
      @start_index ||= @index + 1
    end

    def end_index
      return start_index unless @lines[@index + 1] =~ /^(\s*)(class|def)/

      indent = Regexp.last_match[1].length
      end_line = @lines[@index..].index { _1.match?(/^\s{#{indent}}end/) }
      end_line ? end_line + @index : start_index
    end
  end
end
