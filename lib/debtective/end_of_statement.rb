# frozen_string_literal: true

require "parser/current"

module Debtective
  # Find the index of the line ending a statement
  #
  # EndOfStatement.new(
  #   [
  #     "class User",
  #     "  def example",
  #     "    x + y",
  #     "  end"
  #     "end"
  #   ],
  #   1
  # ).call
  # => 3
  #
  class EndOfStatement
    # @param lines [Array<String>] lines of code
    # @param index [Integer] index of the statement first line
    def initialize(lines, first_line_index)
      @lines = lines
      @first_line_index = first_line_index
    end

    # index of the line ending the statement
    # @return [Integer]
    def call
      suppress_stderr do
        last_line_index || @first_line_index
      end
    end

    private

    # index of the line ending the statement
    # @return[Integer, void]
    # @note it is possible that no line ends the statement
    # especially if first line is not the start of a statement
    def last_line_index
      @lines.index.with_index do |_line, index|
        index > @first_line_index &&
          statement?(index) &&
          !chained?(index)
      end
    end

    # check if the code from first index to given index is a statement
    # e.i. can be parsed by a ruby parser (using whitequark/parser)
    # @param index [Integer]
    # @return boolean
    def statement?(index)
      code = @lines[@first_line_index..index].join("\n")
      ::Parser::CurrentRuby.parse(code)
      true
    rescue Parser::SyntaxError
      false
    end

    # check if current line is chained
    # e.i. next line start with a .
    # @param index [Integer]
    # @return boolean
    def chained?(index)
      @lines[index + 1]&.match?(/^(\s*)\./)
    end

    # silence the $stderr
    # to avoid logs from the parser
    # @return void
    def suppress_stderr
      original_stderr = $stderr.clone
      $stderr.reopen(File.new("/dev/null", "w"))
      yield
    ensure
      $stderr.reopen(original_stderr)
    end
  end
end
