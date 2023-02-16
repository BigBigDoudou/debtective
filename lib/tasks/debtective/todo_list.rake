# frozen_string_literal: true

require "debtective/output_todos"

begin
  require "#{Rails.root}/config/initializers/debtective" if defined?(Rails)
rescue LoadError
  nil
end

namespace :debtective do
  desc "Todo List"
  task :todo_list do
    user_name =
      if ARGV.include?("--me")
        `git config user.name`.strip
      elsif ARGV.include?("--user")
        ARGV[ARGV.index("--user") + 1]
      end

    if user_name
      puts "Searching TODOs from #{user_name}..."
    else
      puts "Searching TODOs..."
    end

    Debtective::OutputTodos.new(user_name, quiet: ARGV.include?("--quiet")).call
  end
end
