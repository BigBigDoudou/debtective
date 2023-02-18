# frozen_string_literal: true

require "debtective/todos/find"

module Debtective
  module Todos
    # Information about the todos in the codebase
    class List
      Author = Struct.new(:email, :name, :todos)

      # @param paths [Array<String>]
      def initialize(paths)
        @paths = paths
      end

      # @return [Array<Debtective::Todos::Todo>]
      def todos
        @todos ||= Debtective::Todos::Find.new(@paths).call
      end

      # @return [Array<Debtective::Todos::List::Author>]
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
              .map { _1.statement_boundaries.to_a }
              .reduce(:|)
              .length
          end
      end

      private

      # @param email_and_name [Array<String>]
      # @return [Debtective::Todos::List::Author]
      def author(email_and_name)
        Author.new(
          *email_and_name,
          todos.select { email_and_name == [_1.commit.author.email, _1.commit.author.name] }
        )
      end
    end
  end
end
