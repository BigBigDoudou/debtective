# frozen_string_literal: true

require "debtective/report"

begin
  require "#{Rails.root}/config/initializers/debtective" if defined?(Rails)
rescue LoadError
  nil
end

namespace :debtective do
  desc "Todo List"
  task :todo_list do
    Debtective::Report.new.call
  end
end
