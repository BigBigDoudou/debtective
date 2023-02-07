# frozen_string_literal: true

require "debtective/end_of_statement"

module Debtective
  # Find the todos comments and their boundaries
  class FileTodos
    Result = Struct.new(:pathname, :boundaries)

    BEFORE_LINE_TODO_REGEX = /^\s*#\stodo:\s/i
    INLINE_TODO_REGEX = /\s*#\stodo:\s/i

    # @param pathname [Pathname]
    def initialize(pathname)
      @pathname = pathname
    end

    # @return [Array<FileTodos::Result>]
    def call
      lines.filter_map.with_index do |line, index|
        case line
        when BEFORE_LINE_TODO_REGEX
          Result.new(@pathname, boundaries(index))
        when INLINE_TODO_REGEX
          Result.new(@pathname, index..index)
        end
      end
    end

    private

    # @return [Array<String>]
    def lines
      @lines ||= @pathname.readlines
    end

    # @param index [Integer]
    # @return [Boundaries]
    def boundaries(index)
      offset = index + 2
      offset..end_line(index) + offset
    end

    # @param index [Integer]
    # @return [Integer]
    def end_line(index)
      next_lines = lines[(index + 1)..]
      EndOfStatement.new(next_lines).call
    end
  end
end
