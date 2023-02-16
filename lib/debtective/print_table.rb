# frozen_string_literal: true

require "debtective/todo_list"

module Debtective
  # Print todos as a table in the stdout
  class PrintTable
    # @param user_name [String] git user email to filter
    def initialize(user_name = nil)
      @user_name = user_name
    end

    # @return [Debtective::TodoList]
    def call
      log_table_headers
      log_table_rows
      todo_list
    end

    private

    # @return [void]
    def log_table_headers
      puts separator
      puts table_row("location", "author", "days", "size")
      puts separator
    end

    # @return [void]
    def log_table_rows
      trace.enable
      todo_list.todos
      trace.disable
      puts separator
    end

    # use a trace to log each todo as soon as it is found
    # @return [Tracepoint]
    def trace
      TracePoint.new(:return) do |trace_point|
        next unless trace_point.defined_class == Debtective::BuildTodo && trace_point.method_id == :call

        todo = trace_point.return_value
        log_todo(todo)
      end
    end

    # if a user_name is given and is not the commit author
    # the line is temporary and will be replaced by the next one
    # @return [void]
    def log_todo(todo)
      row = table_row(
        todo.location,
        todo.commit.author.name || "?",
        todo.days || "?",
        todo.size
      )
      if @user_name.nil? || @user_name == todo.commit.author.name
        puts row
      else
        print "#{row}\r"
      end
    end

    # @return [Debtective::Todo]
    def todo_list
      @todo_list ||= Debtective::TodoList.new(
        Debtective.configuration&.paths || ["./**/*"]
      )
    end

    # @return [String]
    def table_row(location, author, days, size)
      [
        format("%-80.80s", location),
        format("%-20.20s", author),
        format("%-12.12s", days),
        format("%-12.12s", size)
      ].join(" | ")
    end

    # @return [String]
    def separator
      @separator ||= Array.new(table_row(nil, nil, nil, nil).size) { "-" }.join
    end
  end
end
