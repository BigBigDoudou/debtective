# frozen_string_literal: true

require "json"
require "debtective/find_todos"
require "debtective/todos_counts"

module Debtective
  # Generate todolist
  class OutputTodos
    DIRECTORY_PATH = "debtective"
    FILE_PATH = "#{DIRECTORY_PATH}/todos.json"

    # @return [void]
    def call
      log_todos
      update_json_file
    end

    private

    # @return [void]
    def log_todos
      puts separator
      log_table_headers
      puts separator
      log_table_rows
      puts separator
      log_todos_count
      log_combined_count
      log_extended_count
      puts separator
    end

    # @return [void]
    def update_json_file
      create_directory
      File.open(FILE_PATH, "w") do |file|
        file.puts JSON.pretty_generate(todos_hash)
      end
      puts FILE_PATH
      puts separator
    end

    # @return [Hash]
    def todos_hash
      todos.map do |todo|
        {
          pathname: todo.pathname,
          location: todo.location,
          line_numbers: todo.line_numbers,
          size: todo.size,
          author: {
            name: todo.commit.author&.name,
            email: todo.commit.author&.email
          },
          datetime: todo.commit.datetime
        }
      end
    end

    # @return [void]
    def create_directory
      return if File.directory?(DIRECTORY_PATH)

      FileUtils.mkdir_p(DIRECTORY_PATH)
    end

    # @return [void]
    def log_table_headers
      puts table_row("location", "author", "date")
    end

    # @return [void]
    def log_table_rows
      todos
    end

    # @return [void]
    def log_todos_count
      puts "count: #{todos.count}"
    end

    # @return [void]
    def log_combined_count
      puts "combined lines count: #{counts.combined_count}"
    end

    # @return [void]
    def log_extended_count
      puts "extended lines count: #{counts.extended_count}"
    end

    # @return [Debtective::Todo]
    def todos
      @todos ||= Debtective::FindTodos.new(paths, hook: hook).call
    end

    # @return [Debtective::TodosCount]
    def counts
      @counts ||= Debtective::TodosCounts.new(todos)
    end

    # @return [String]
    def paths
      Debtective.configuration&.paths || ["./**/*"]
    end

    # @return [Lambda]
    def hook
      lambda do |todo|
        puts(
          table_row(
            todo.location,
            todo.commit.author.name || "?",
            todo.commit.datetime&.strftime("%F") || "?"
          )
        )
      end
    end

    # @return [String]
    def separator
      @separator ||= Array.new(table_row(nil, nil, nil).size) { "-" }.join
    end

    # @return [String]
    def table_row(col1, col2, col3)
      [
        format("%-80.80s", col1.to_s),
        format("%-20.20s", col2.to_s),
        format("%-12.12s", col3.to_s)
      ].join(" | ")
    end
  end
end
