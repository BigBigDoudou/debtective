# frozen_string_literal: true

require "json"
require "debtective/print_table"
require "pry"

module Debtective
  # Generate todolist
  class OutputTodos
    FILE_PATH = "todos.json"

    # @param user_name [String] git user email to filter
    def initialize(user_name = nil, quiet: false)
      @user_name = user_name
      @quiet = quiet
    end

    # @return [void]
    def call
      @todo_list = log_table
      @todo_list ||= Debtective::TodoList.new(Debtective.configuration&.paths || ["./**/*"])
      filter_todo_list!
      log_counts
      update_json_file
      puts FILE_PATH
    end

    private

    # @return [void]
    def log_table
      return if @quiet

      Debtective::PrintTable.new(@user_name).call
    end

    # @return [void]
    def filter_todo_list!
      !@user_name.nil? && @todo_list.todos.select! { _1.commit.author.name == @user_name }
    end

    # @return [void]
    def log_counts
      @return if @quiet

      puts "total: #{@todo_list.todos.count}"
      puts "combined lines count: #{@todo_list.combined_count}"
      puts "extended lines count: #{@todo_list.extended_count}"
    end

    # @return [void]
    def update_json_file
      File.open(FILE_PATH, "w") do |file|
        file.puts(
          JSON.pretty_generate(
            @todo_list.todos.map(&:to_h)
          )
        )
      end
    end
  end
end
