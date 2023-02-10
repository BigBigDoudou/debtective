# frozen_string_literal: true

require "debtective/end_of_statement"

module Debtective
  # Hold todo information
  class Todo
    attr_accessor :pathname, :todo_index, :boundaries

    # @param pathname [Pathname]
    # @param todo_index [Integer] first line of todo comment
    # @param boundaries [Range] first and last index of the concerned code
    def initialize(pathname, todo_index, boundaries)
      @pathname = pathname
      @todo_index = todo_index
      @boundaries = boundaries
    end

    # location in the codebase
    # @return [String]
    def location
      "#{pathname}:#{todo_index + 1}"
    end

    # size of the todo code
    # @return [Integer]
    def size
      boundaries.size
    end

    # line numbers (like displayed in an IDE)
    # @return [Range]
    def line_numbers
      (boundaries.min + 1)..(boundaries.max + 1)
    end
  end
end
