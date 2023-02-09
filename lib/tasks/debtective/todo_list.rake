# frozen_string_literal: true

require "debtective/todo_list"

begin
  require "#{Rails.root}/config/initializers/debtective" if defined?(Rails)
rescue LoadError
  nil
end

namespace :debtective do
  desc "Todo List"
  task :todo_list do
    todo_list = Debtective::TodoList.new.call
    todos = todo_list.todos.sort_by { _1.boundaries.size }.reverse

    separator = Array.new(120 + 3 + 12 + 3 + 12) { "-" }.join

    puts separator

    puts "todo list"

    puts separator

    puts(
      [
        "pathname".ljust(120),
        "lines".rjust(12)
      ].join(" | ")
    )

    puts separator

    todos.each do |todo|
      location = "#{todo.pathname}:#{todo.todo_index + 1}".ljust(120)
      puts(
        [
          location,
          [todo.boundaries.first + 1, todo.boundaries.last + 1].join(":").rjust(12),
          todo.boundaries.size.to_s.rjust(12)
        ].join(" | ")
      )
    end

    puts separator

    puts "todos count"
    puts todos.count

    puts separator

    puts "combined lines count"
    puts todo_list.combined_count

    puts separator

    puts "extended lines count"
    puts todo_list.extended_count

    puts separator
  end
end
