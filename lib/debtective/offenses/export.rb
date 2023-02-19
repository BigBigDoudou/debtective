# frozen_string_literal: true

require "debtective/export"
require "debtective/print"
require "debtective/find"
require "debtective/offenses/offense"

module Debtective
  module Offenses
    # Export offenses
    class Export < Debtective::Export
      private

      FILE_PATH = "offenses.json"

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
          "cop",
          "%-27.27s",
          -> { _1.cop || "?" }
        )
      ].freeze

      # @return [void]
      def log_table
        Debtective::Print.new(
          columns: TABLE_COLUMNS,
          track: Debtective::Offenses::Offense,
          user_name: @user_name
        ).call { @elements = find_elements }
      end

      def find_elements
        Debtective::Find.new(
          paths,
          /\s# rubocop:disable (.*)/,
          ->(pathname, index, match) { Debtective::Offenses::Offense.new(pathname, index, match[1]) }
        ).call
      end
    end
  end
end
