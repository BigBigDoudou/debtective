# frozen_string_literal: true

require "debtective/todos/todo"
require "debtective/find_end_of_statement"

module Debtective
  module Todos
    # Build a Todo object given the pathname and the comment index
    class Build
      BEFORE_LINE_TODO_REGEX = /^\s*#\sTODO:\s/
      INLINE_TODO_REGEX = /\s*#\sTODO:\s/
      COMMENT_REGEX = /^\s*#/

      # @param pathname [Pathname]
      # @param index [Integer]
      def initialize(pathname:, index:)
        @pathname = pathname
        @index = index
      end

      # @return [Debtective::Todos::Todo]
      def call
        Debtective::Todos::Todo.new(
          pathname: @pathname,
          lines: lines,
          todo_boundaries: todo_boundaries,
          statement_boundaries: statement_boundaries
        )
      end

      private

      # @return [Array<String>]
      def lines
        @lines ||= @pathname.readlines
      end

      # @return [Range]
      def todo_boundaries
        @index..([@index, statement_boundaries.min - 1].max)
      end

      # range of the concerned code
      # @return [Range]
      def statement_boundaries
        @statement_boundaries ||=
          case lines[@index]
          when BEFORE_LINE_TODO_REGEX
            first_line_index = statement_start
            last_line_index = Debtective::FindEndOfStatement.new(lines: lines, first_line_index: first_line_index).call
            first_line_index..last_line_index
          when INLINE_TODO_REGEX
            @index..@index
          end
      end

      # start index of the concerned code (i.e. below the TODO comment)
      # @return [Integer]
      def statement_start
        lines.index.with_index do |line, i|
          i > @index &&
            !line.strip.empty? &&
            !line.match?(COMMENT_REGEX)
        end
      end
    end
  end
end
