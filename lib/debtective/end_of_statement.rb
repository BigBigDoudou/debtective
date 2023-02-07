# frozen_string_literal: true

module Debtective
  # Find end of a block given its first line and the next lines
  #
  # With a class, a def, an if statement... or any "block statement"
  #
  # 0   def foo
  # 1     do_this <--
  # 2   end
  # 3 end
  #
  # The end of the block is the last line before the `end` keyword (index 1)
  #
  # With a carriage return
  #
  # 0   User
  # 1     .where(draft: true)
  # 2     .preload(:tasks)    <--
  # 3 end
  #
  # The end of the block is the last line of the statement (index 2)
  #
  # With a single line (no block)
  #
  # 0   do_this <--
  # 1   do_that
  # 2 end
  #
  # Then the end is the first line (index 0)
  #
  class EndOfStatement
    NON_ENDING_KEYWORDS_REGEX = /^(\s*)(else$|elsif\s|(rescue(\s|$))|ensure)/

    # @param lines [Array<String>] lines of code
    def initialize(lines)
      @lines = lines
    end

    # ends of the statement
    # @return [Integer]
    def call
      @lines[1..].index { end_of_statement?(_1) } || 0
    end

    private

    # indent (number of spaces) of the first line | for memoization
    # @return [Integer]
    def first_line_indent
      @first_line_indent ||= indent(@lines[0])
    end

    # return true if the line is the end of the statement
    # @return [Boolean]
    def end_of_statement?(line)
      return false if line.match?(NON_ENDING_KEYWORDS_REGEX)

      indent(line) <= first_line_indent
    end

    # returns the indent (number of spaces) of the line
    # @param line [String]
    # @return [Integer]
    def indent(line)
      line.match(/^(\s*).*$/)[1].length
    end
  end
end
