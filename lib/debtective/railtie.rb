# frozen_string_literal: true

module Debtective
  # Makes Rails aware of the tasks
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/debtective/todo_list.rake"
    end
  end
end
