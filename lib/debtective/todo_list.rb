# frozen_string_literal: true

require "debtective/find_todos"

module Debtective
  # Information about the todos in the codebase
  class TodoList
    Author = Struct.new(:email, :name, :todos)

    # @param paths [Array<String>]
    # @param hook [Lambda]
    def initialize(paths, hook: nil)
      @paths = paths
      @hook = hook
    end

    # @return [Array<Debtective::Todo>]
    def todos
      @todos ||= Debtective::FindTodos.new(@paths, hook: @hook).call
    end

    # @return [Array<TodoList::Author>]
    def authors
      todos
        .map { [_1.commit.author.email, _1.commit.author.name] }
        .uniq
        .map { author(_1) }
    end

    # @return [Integer]
    def extended_count
      todos.sum(&:size)
    end

    # @return [Integer]
    def combined_count
      todos
        .group_by(&:pathname)
        .values
        .sum do |pathname_todos|
          pathname_todos
            .map { _1.boundaries.to_a }
            .reduce(:|)
            .length
        end
    end

    private

    # @param email_and_name [Array<String>]
    # @return [TodoList::Author]
    def author(email_and_name)
      Author.new(
        *email_and_name,
        todos.select { email_and_name == [_1.commit.author.email, _1.commit.author.name] }
      )
    end
  end
end
