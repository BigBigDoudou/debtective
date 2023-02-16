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
    if ARGV.include?("--me")
      user_name = `git config user.name`.strip
      puts "Searching TODOs from #{user_name}..."
    else
      puts "Searching TODOs..."
    end
    Debtective::OutputTodos.new(user_name, quiet: ARGV.include?("--quiet")).call
  end
end
