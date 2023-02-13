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
    Debtective::OutputTodos.new.call
  end
end
