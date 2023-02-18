# frozen_string_literal: true

module Debtective
  # Print elements as a table in the stdout
  class PrintTable
    # @param user_name [String] git user email to filter
    def initialize(user_name = nil)
      @user_name = user_name
    end

    # @return [Debtective::Offenses::List]
    def call
      log_table_headers
      log_table_rows
      elements
    end

    private

    KLASS = nil
    HEADERS = [].freeze

    def paths
      Debtective.configuration&.paths || ["./**/*"]
    end

    # @return [void]
    def log_table_headers
      puts separator
      puts table_row(*self.class::HEADERS)
      puts separator
    end

    # @return [void]
    def log_table_rows
      trace.enable
      elements
      trace.disable
      puts separator
    end

    # use a trace to log each element as soon as it is found
    # @return [Tracepoint]
    def trace
      TracePoint.new(:return) do |trace_point|
        next unless trace_point.defined_class == self.class::KLASS && trace_point.method_id == :initialize

        element = trace_point.self
        log_element(element)
      end
    end

    # if a user_name is given and is not the commit author
    # the line is temporary and will be replaced by the next one
    # @return [void]
    def log_element(element)
      if @user_name.nil? || @user_name == element.commit.author.name
        puts element_row(element)
      else
        print "#{element_row(element)}\r"
      end
    end

    # @return [String]
    def separator
      @separator ||= Array.new(table_row(*Array.new(self.class::HEADERS.size)).size) { "-" }.join
    end
  end
end
