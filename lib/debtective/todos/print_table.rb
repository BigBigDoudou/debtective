# frozen_string_literal: true

require "debtective/todos/find"
require "debtective/print_table"

module Debtective
  module Todos
    # Print todos as a table in the stdout
    class PrintTable < Debtective::PrintTable
      private

      KLASS = Debtective::Todos::Todo
      HEADERS = %w[location author days size].freeze

      # @return [Array<Debtective::Todos::Todo>]
      def elements
        @elements ||= Debtective::Todos::Find.new(paths).call
      end

      # @return [String]
      def table_row(location, author, days, size)
        [
          format("%-80.80s", location),
          format("%-20.20s", author),
          format("%-12.12s", days),
          format("%-12.12s", size)
        ].join(" | ")
      end

      def element_row(todo)
        table_row(
          todo.location,
          todo.commit.author.name || "?",
          todo.days || "?",
          todo.size
        )
      end
    end
  end
end
