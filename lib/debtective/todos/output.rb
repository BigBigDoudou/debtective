# frozen_string_literal: true

require "debtective/output"
require "debtective/todos/print_table"
require "debtective/todos/find"

module Debtective
  module Todos
    # Output todos
    class Output < Debtective::Output
      private

      FILE_PATH = "todos.json"

      # @return [void]
      def log_table
        Debtective::Todos::PrintTable.new(@user_name).call
      end

      # @return [Array<Debtective::Todos::Todo>]
      def find_todos
        Debtective::Todos::Find.new(paths).call
      end

      # @return [void]
      def log_counts
        puts "total: #{@elements.count}"
        puts "extended lines count: #{@extended_count}"
        puts "combined lines count: #{@combined_count}"
      end

      # @return [Integer]
      def extended_count
        @elements.sum(&:size)
      end

      # @return [Integer]
      def combined_count
        @elements
          .group_by(&:pathname)
          .values
          .sum do |pathname_todos|
            pathname_todos
              .map { _1.statement_boundaries.to_a }
              .reduce(:|)
              .length
          end
      end
    end
  end
end
