# frozen_string_literal: true

require "debtective/export"
require "debtective/offenses/find"

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
        ).call do
          @elements = Debtective::Offenses::Find.new(paths).call
        end
      end
    end
  end
end
