# frozen_string_literal: true

module Debtective
  # Apply calculations on a todo list
  class TodosCounts
    # @param todos [Array<Debtective::Todo>]
    def initialize(todos)
      @todos = todos
    end

    # @return [Integer]
    def extended_count
      @todos.sum(&:size)
    end

    # @return [Integer]
    def combined_count
      @todos
        .group_by(&:pathname)
        .values
        .sum do |pathname_todos|
          pathname_todos
            .map { _1.boundaries.to_a }
            .reduce(:|)
            .length
        end
    end
  end
end
