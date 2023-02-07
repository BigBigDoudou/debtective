# frozen_string_literal: true

require "debtective/report"

begin
  require "#{Rails.root}/config/initializers/debtective" if defined?(Rails)
rescue LoadError
  nil
end

namespace :debtective do
  desc "TODOs report"
  task :report do
    report = Debtective::Report.new.call

    p report.todos.map { [_1.pathname.to_s, _1.boundaries.start, _1.boundaries.end] }
    puts "----------"
    puts "combined count"
    p report.combined_count
    puts "----------"
    puts "extended count"
    p report.extended_count
  end
end
