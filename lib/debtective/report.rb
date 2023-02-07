# frozen_string_literal: true

require "debtective/todo_list"

module Debtective
  # Output information about the debt
  class Report
    # output todo list
    def call
      puts_separator
      puts "todo list"
      puts_separator
      puts table_header
      puts_separator
      puts_table_content
      puts_separator
      puts_todos_count
      puts_separator
      puts_combines_lines_count
      puts_separator
      puts_extended_lines_count
      puts_separator
    end

    private

    # @return [TodoList::Result]
    def todo_list
      @todo_list ||= Debtective::TodoList.new.call
    end

    # @return [Array<FileTodos::Result>]
    def todos
      @todos ||= todo_list.todos.sort_by { _1.boundaries.size }.reverse
    end

    # @return [String]
    def puts_separator
      puts Array.new(table_header.length) { "-" }.join
    end

    # @return [void]
    def table_header
      @table_header ||= [
        "pathname".ljust(120),
        "boundaries".rjust(12),
        "lines".rjust(12)
      ].join(" | ")
    end

    # @return [void]
    def puts_table_content
      todos.each do |todo|
        puts(
          [
            todo.pathname.to_s.ljust(120),
            todo.boundaries.to_s.rjust(12),
            todo.boundaries.size.to_s.rjust(12)
          ].join(" | ")
        )
      end
    end

    # @return [void]
    def puts_todos_count
      puts "todos count"
      puts todos.count
    end

    # @return [void]
    def puts_combines_lines_count
      puts "combined lines count"
      puts todo_list.combined_count
    end

    # @return [void]
    def puts_extended_lines_count
      puts "extended lines count"
      puts todo_list.extended_count
    end
  end
end
