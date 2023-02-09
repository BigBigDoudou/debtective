# frozen_string_literal: true

require "debtective/end_of_statement"

module Debtective
  # Find the todos comments and their boundaries
  class FileTodos
    Result = Struct.new(:pathname, :boundaries)

    BEFORE_LINE_TODO_REGEX = /^\s*#\sTODO:\s/
    INLINE_TODO_REGEX = /\s*#\sTODO:\s/
    COMMENT_REGEX = /\s*#/

    # @param pathname [Pathname]
    def initialize(pathname)
      @pathname = pathname
    end

    # @return [Array<FileTodos::Result>]
    def call
      lines.filter_map.with_index do |line, index|
        boundaries = boundaries(line, index)
        next if boundaries.nil?

        Result.new(@pathname, boundaries)
      end
    end

    private

    # return todo boundaries if there is a todo
    # @param line [String]
    # @param index [Integer]
    # @return [Range, nil]
    def boundaries(line, index)
      case line
      when BEFORE_LINE_TODO_REGEX
        first_line_index = statement_first_line_index(index)
        last_line_index = EndOfStatement.new(@lines, first_line_index).call
        first_line_index..last_line_index
      when INLINE_TODO_REGEX
        index..index
      end
    end

    # @return [Array<String>]
    def lines
      @lines ||= @pathname.readlines
    end

    # @param todo_index [Integer]
    # @return [Integer]
    def statement_first_line_index(todo_index)
      @lines.index.with_index do |line, i|
        i > todo_index &&
          !line.strip.empty? &&
          !line.match?(COMMENT_REGEX)
      end
    end
  end
end
