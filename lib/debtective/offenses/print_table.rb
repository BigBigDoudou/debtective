# frozen_string_literal: true

require "debtective/offenses/find"

module Debtective
  module Offenses
    # Print offenses as a table in the stdout
    class PrintTable
      # @param user_name [String] git user email to filter
      def initialize(user_name = nil)
        @user_name = user_name
      end

      # @return [Debtective::Offenses::List]
      def call
        log_table_headers
        log_table_rows
        offenses
      end

      private

      # @return [void]
      def log_table_headers
        puts separator
        puts table_row("location", "cop", "author")
        puts separator
      end

      # @return [void]
      def log_table_rows
        trace.enable
        offenses
        trace.disable
        puts separator
      end

      # use a trace to log each offense as soon as it is found
      # @return [Tracepoint]
      def trace
        TracePoint.new(:return) do |trace_point|
          next unless trace_point.defined_class == Debtective::Offenses::Offense && trace_point.method_id == :initialize

          offense = trace_point.self
          log_offense(offense) if offense
        end
      end

      # if a user_name is given and is not the commit author
      # the line is temporary and will be replaced by the next one
      # @return [void]
      def log_offense(offense)
        row = table_row(
          offense.location,
          offense.cop || "?",
          offense.commit.author.name || "?"
        )
        if @user_name.nil? || @user_name == offense.commit.author.name
          puts row
        else
          print "#{row}\r"
        end
      end

      # @return [Array<Debtective::Offenses::Offense>]
      def offenses
        @offenses ||= Debtective::Offenses::Find.new(
          Debtective.configuration&.paths || ["./**/*"]
        ).call
      end

      # @return [String]
      def table_row(location, cop, author)
        [
          format("%-72.72s", location),
          format("%-20.20s", cop),
          format("%-20.20s", author)
        ].join(" | ")
      end

      # @return [String]
      def separator
        @separator ||= Array.new(table_row(nil, nil, nil).size) { "-" }.join
      end
    end
  end
end
