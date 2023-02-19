# frozen_string_literal: true

module Debtective
  # Print elements as a table in the stdout
  class Print
    Column = Struct.new(:name, :format, :lambda)

    # @param user_name [String] git user email to filter
    def initialize(columns:, track:, user_name: nil)
      @columns = columns
      @track = track
      @user_name = user_name
    end

    # @return [Debtective::Offenses::List]
    def call
      puts separator
      puts headers_row
      puts separator
      trace.enable
      yield
      trace.disable
      puts separator
    end

    private

    # use a trace to log each element as soon as it is found
    # @return [Tracepoint]
    def trace
      TracePoint.new(:return) do |trace_point|
        next unless trace_point.defined_class == @track && trace_point.method_id == :initialize

        object = trace_point.self
        log_object(object)
      end
    end

    def headers_row
      @columns.map do |column|
        format(column.format, column.name)
      end.join(" | ")
    end

    def object_row(object)
      @columns.map do |column|
        format(column.format, column.lambda.call(object))
      end.join(" | ")
    end

    # if a user_name is given and is not the commit author
    # the line is temporary and will be replaced by the next one
    # @return [void]
    def log_object(object)
      if @user_name.nil? || @user_name == object.commit.author.name
        puts object_row(object)
      else
        print "#{object_row(object)}\r"
      end
    end

    # @return [String]
    def separator
      @separator ||=
        begin
          size = @columns.map { format(_1.format, "") }.join("---").size
          "-" * size
        end
    end
  end
end
