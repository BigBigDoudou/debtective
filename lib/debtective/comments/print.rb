# frozen_string_literal: true

require_relative "export"

module Debtective
  module Comments
    # Print elements as a table in the stdout and return the block result
    class Print
      Column = Struct.new(:name, :format, :lambda)

      COLUMNS = [
        Column.new(
          "location",
          "%-100.100s",
          -> { _1.location }
        ),
        Column.new(
          "type",
          "%-7.7s",
          -> { _1.type }
        ),
        Column.new(
          "author",
          "%-20.20s",
          -> { _1.commit.author.name || "?" }
        )
      ].freeze

      # @param user_name [String] git user name to filter with
      def initialize(user_name: nil)
        @user_name = user_name
      end

      # @return [Object] yielded bloc result
      def call
        puts separator
        puts headers_row
        puts separator
        trace.enable
        result = yield
        trace.disable
        puts separator
        result
      end

      private

      # Use a trace to log each element as soon as it is exported
      # @return [Tracepoint]
      def trace
        TracePoint.new(:return) do |trace_point|
          next unless trace_point.defined_class == Export && trace_point.method_id == :export_comment

          log_comment(trace_point.return_value)
        end
      end

      def headers_row
        COLUMNS.map { format(_1.format, _1.name) }.join(" | ")
      end

      def comment_row(comment)
        COLUMNS.map { format(_1.format, _1.lambda.call(comment)) }.join(" | ")
      end

      # If a user_name is given and is not the commit author
      # the line is temporary and will be replaced by the next one
      def log_comment(comment)
        return if comment.nil?

        if @user_name.nil? || @user_name == comment.commit.author.name
          puts comment_row(comment)
        else
          print "#{comment_row(comment)}\r"
        end
      end

      def separator
        @separator ||= "-" * COLUMNS.map { format(_1.format, "") }.join("---").size
      end
    end
  end
end
