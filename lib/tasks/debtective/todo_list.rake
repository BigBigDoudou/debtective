# frozen_string_literal: true

require "debtective/todo_list"
require "debtective/todo_list_counts"

begin
  require "#{Rails.root}/config/initializers/debtective" if defined?(Rails)
rescue LoadError
  nil
end

namespace :debtective do
  desc "Todo List"
  task :todo_list do
    array_row =
      lambda do |value1, value2, value3|
        [
          value1.to_s.ljust(120),
          value2.to_s.rjust(12),
          value3.to_s.rjust(12)
        ].join(" | ").prepend("| ").concat(" |")
      end

    separator = Array.new(array_row.call(nil, nil, nil).size) { "-" }.join

    todo_list = Debtective::TodoList.new.call
    todos = todo_list.sort_by { _1.boundaries.size }.reverse
    todo_list_counts = Debtective::TodoListCounts.new(todos)

    puts separator
    puts "todo list"
    puts separator
    puts array_row.call("pathname", "line numbers", "lines count")
    puts separator
    todos.each { puts array_row.call(_1.location, _1.line_numbers, _1.size) }

    puts separator
    puts "todos count"
    puts todos.count

    puts separator
    puts "combined lines count"
    puts todo_list_counts.combined_count

    puts separator
    puts "extended lines count"
    puts todo_list_counts.extended_count

    puts separator
  end
end
