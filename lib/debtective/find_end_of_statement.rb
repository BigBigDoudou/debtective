# frozen_string_literal: true

require "debtective/stderr_helper"

module Debtective
  # Find the index of the line ending a statement
  #
  # @example
  #   FindEndOfStatement.new(
  #     [
  #       "class User",
  #       "  def example",
  #       "    x + y",
  #       "  end"
  #       "end"
  #     ],
  #     1
  #   ).call
  #   => 3
  #
  class FindEndOfStatement
    include StderrHelper

    # @param lines [Array<String>] lines of code
    # @param index [Integer] index of the statement first line
    def initialize(lines:, first_line_index:)
      @lines = lines
      @first_line_index = first_line_index
    end

    # index of the line ending the statement
    # @return [Integer]
    # @note use suppress_stderr to prevent error outputs
    #   from RubyVM::InstructionSequence.compile
    def call
      suppress_stderr { last_line_index }
    end

    private

    # recursively find index of the line ending the statement
    # @param index [Integer] used for recursion
    # @return[Integer, void]
    # @note it is possible that no line ends the statement
    # especially if first line is not the start of a statement
    def last_line_index(index = @first_line_index)
      return @first_line_index if index >= @lines.size
      return index if !chained?(index) && statement?(index)

      last_line_index(index + 1)
    end

    # check if the code from first index to given index is a statement
    # e.i. can be parsed by a ruby parser (using whitequark/parser)
    # @param index [Integer]
    # @return boolean
    def statement?(index)
      code = @lines[@first_line_index..index].join("\n")
      RubyVM::InstructionSequence.compile(code)
    rescue SyntaxError
      false
    end

    # check if current line is chained
    # e.i. next line start with a .
    # @param index [Integer]
    # @return boolean
    def chained?(index)
      @lines[index + 1]&.match?(/^(\s*)\./)
    end
  end
end
