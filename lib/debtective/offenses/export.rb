# frozen_string_literal: true

require "debtective/export"
require "debtective/print"
require "debtective/offenses/offense"

module Debtective
  module Offenses
    # Export offenses in a JSON file
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

      # @return [Array<Debtective::Offenses::Offense>]
      def log_table
        Debtective::Print.new(
          columns: TABLE_COLUMNS,
          track: Debtective::Offenses::Offense,
          user_name: @user_name
        ).call { find_elements }
      end

      # @return [Array<Debtective::Offenses::Offense>]
      def find_elements
        pathnames.flat_map do |pathname|
          pathname.readlines.filter_map.with_index do |line, index|
            next unless line =~ /\s# rubocop:disable (.*)/

            Debtective::Offenses::Offense.new(
              pathname: pathname,
              index: index,
              cop: Regexp.last_match[1]
            )
          end
        end
      end
    end
  end
end
