# frozen_string_literal: true

require "debtective/print_table"
require "debtective/offenses/find"

module Debtective
  module Offenses
    # Print offenses as a table in the stdout
    class PrintTable < Debtective::PrintTable
      private

      KLASS = Debtective::Offenses::Offense
      HEADERS = %w[location cop author].freeze

      # @return [Array<Debtective::Offenses::Offense>]
      def elements
        @elements ||= Debtective::Offenses::Find.new(paths).call
      end

      # @return [String]
      def table_row(location, cop, author)
        [
          format("%-72.72s", location),
          format("%-20.20s", cop),
          format("%-20.20s", author)
        ].join(" | ")
      end

      def element_row(offense)
        table_row(
          offense.location,
          offense.cop || "?",
          offense.commit.author.name || "?"
        )
      end
    end
  end
end
