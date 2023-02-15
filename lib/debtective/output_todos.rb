# frozen_string_literal: true

require "json"
require "debtective/todo_list"

module Debtective
  # Generate todolist
  class OutputTodos
    FILE_PATH = "todos.json"

    # @return [void]
    def call
      log_table_headers
      log_table_rows
      log_counts
      update_json_file
    end

    private

    # @return [void]
    def update_json_file
      File.open(FILE_PATH, "w") do |file|
        file.puts(
          JSON.pretty_generate(
            todo_list.todos.map(&:to_h)
          )
        )
      end
      puts FILE_PATH
      puts separator
    end

    # @return [void]
    def create_directory
      return if File.directory?(DIRECTORY_PATH)

      FileUtils.mkdir_p(DIRECTORY_PATH)
    end

    # @return [void]
    def log_table_headers
      puts separator
      puts table_row("location", "author", "days", "size")
      puts separator
    end

    # @return [void]
    def log_table_rows
      with_trace_logs(
        lambda do |todo|
          puts(
            table_row(
              todo.location,
              todo.commit.author.name || "?",
              todo.days || "?",
              todo.size
            )
          )
        end
      ) do
        todo_list.todos
      end
      puts separator
    end

    # @param lambda [Lambda]
    # @yield
    def with_trace_logs(lambda)
      trace =
        TracePoint.new(:return) do |trace_point|
          next unless trace_point.defined_class == Debtective::BuildTodo && trace_point.method_id == :call

          todo = trace_point.return_value
          lambda.call(todo)
        end
      trace.enable
      yield
      trace.disable
    end

    # @return [Debtective::Todo]
    def todo_list
      @todo_list ||= Debtective::TodoList.new(
        Debtective.configuration&.paths || ["./**/*"]
      )
    end

    # @return [void]
    def log_counts
      puts "count: #{todo_list.todos.count}"
      puts "combined lines count: #{todo_list.combined_count}"
      puts "extended lines count: #{todo_list.extended_count}"
      puts separator
    end

    # @return [String]
    def separator
      @separator ||= Array.new(table_row(nil, nil, nil, nil).size) { "-" }.join
    end

    # @return [String]
    def table_row(col1, col2, col3, col4)
      [
        format("%-80.80s", col1.to_s),
        format("%-20.20s", col2.to_s),
        format("%-12.12s", col3.to_s),
        format("%-12.12s", col4.to_s)
      ].join(" | ")
    end
  end
end
