# frozen_string_literal: true

require "debtective/todo"
require "debtective/end_of_statement"

module Debtective
  # Find the todos comments and their boundaries
  class TodoBuilder
    BEFORE_LINE_TODO_REGEX = /^\s*#\sTODO:\s/
    INLINE_TODO_REGEX = /\s*#\sTODO:\s/
    COMMENT_REGEX = /\s*#/

    # @param pathname [Pathname]
    # @param index [Integer]
    def initialize(pathname, index)
      @pathname = pathname
      @index = index
    end

    # @return [Debtective::Todo]
    def call
      Todo.new(
        @pathname,
        @index,
        boundaries,
        commit
      )
    end

    private

    # @return [Array<String>]
    def lines
      @lines ||= @pathname.readlines
    end

    # range of the concerned code
    # @return [Range, nil]
    def boundaries
      @boundaries ||=
        case lines[@index]
        when BEFORE_LINE_TODO_REGEX
          first_line_index = statement_start
          last_line_index = EndOfStatement.new(lines, first_line_index).call
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

    # return commit that introduced the todo
    # @return [Git::Object::Commit]
    def commit
      Debtective::GitCommit.new(@pathname, lines[@index]).call
    end
  end
end
