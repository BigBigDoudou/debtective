# frozen_string_literal: true

require "debtective/export"
require "debtective/print"
require "debtective/find"
require "debtective/todos/build"
require "debtective/todos/todo"

module Debtective
  module Todos
    # Export todos
    class Export < Debtective::Export
      private

      FILE_PATH = "todos.json"

      TABLE_COLUMNS = [
        Debtective::Print::Column.new(
          "location",
          "%-80.80s",
          -> { _1.location }
        ),
        Debtective::Print::Column.new(
          "author",
          "%-20.20s",
          -> { _1.commit.author.name || "?" }
        ),
        Debtective::Print::Column.new(
          "days",
          "%-12.12s",
          -> { _1.days || "?" }
        ),
        Debtective::Print::Column.new(
          "size",
          "%-12.12s",
          -> { _1.size }
        )
      ].freeze

      # @return [void]
      def log_table
        Debtective::Print.new(
          columns: TABLE_COLUMNS,
          track: Debtective::Todos::Todo,
          user_name: @user_name
        ).call do
          @elements = find_elements
        end
      end

      def find_elements
        Debtective::Find.new(
          paths,
          /#\sTODO:/,
          ->(pathname, index, _match) { Debtective::Todos::Build.new(pathname, index).call }
        ).call
      end

      # @return [void]
      def log_counts
        puts "total: #{@elements.count}"
        puts "extended lines count: #{extended_count}"
        puts "combined lines count: #{combined_count}"
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
