# frozen_string_literal: true

module Debtective
  module Comments
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
      # @param lines [Array<String>] lines of code
      # @param first_line_index [Integer] index of the statement first line
      def initialize(lines:, first_line_index:)
        @lines = lines
        @first_line_index = first_line_index
      end

      # @return [Integer] index of the line ending the statement
      # @note suppress_stderr prevents outputs from RubyVM::InstructionSequence.compile
      def call
        last_line_index
      end

      private

      # Recursively find index of the line ending the statement
      # (it is possible that no line ends the statement
      # especially if the first line is not the start of a statement)
      def last_line_index(index = @first_line_index)
        return @first_line_index if index >= @lines.size
        return index if !chained?(index) && statement?(index)

        last_line_index(index + 1)
      end

      # Check if the code from first index to given index is a statement,
      # e.i. can be parsed by a ruby parser (using whitequark/parser)
      def statement?(index)
        code = @lines[@first_line_index..index].join("\n")
        RubyVM::InstructionSequence.compile(code)
      rescue SyntaxError
        false
      end

      # Check if current line is chained, e.i. next line start with a "."
      def chained?(index)
        @lines[index + 1]&.match?(/^(\s*)\./)
      end
    end
  end
end
