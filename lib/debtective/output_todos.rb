# frozen_string_literal: true

require "json"
require "debtective/todo_list"

module Debtective
  # Generate todolist
  class OutputTodos
    DIRECTORY_PATH = "debtective"
    FILE_PATH = "#{DIRECTORY_PATH}/todos.json".freeze

    # @return [void]
    def call
      log_table
      log_counts
      update_json_file
    end

    private

    # @return [void]
    def update_json_file
      create_directory
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
    def log_table
      puts separator
      puts table_row("location", "author", "date", "size")
      puts separator
      todo_list.todos
      puts separator
    end

    # @return [void]
    def log_counts
      puts "count: #{todo_list.todos.count}"
      puts "combined lines count: #{todo_list.combined_count}"
      puts "extended lines count: #{todo_list.extended_count}"
      puts separator
    end

    # @return [Debtective::Todo]
    def todo_list
      @todo_list ||= Debtective::TodoList.new(paths, hook: hook)
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
            todo.commit.time&.strftime("%F") || "?",
            todo.size
          )
        )
      end
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
