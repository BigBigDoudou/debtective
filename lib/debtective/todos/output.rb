# frozen_string_literal: true

require "json"
require "debtective/todos/print_table"

module Debtective
  module Todos
    # Generate todolist
    class Output
      FILE_PATH = "todos.json"

      # @param user_name [String] git user email to filter
      def initialize(user_name = nil, quiet: false)
        @user_name = user_name
        @quiet = quiet
      end

      # @return [void]
      def call
        @list = log_table
        @list ||= Debtective::Todos::List.new(Debtective.configuration&.paths || ["./**/*"])
        filter_list!
        log_counts
        update_json_file
        return if @quiet

        puts FILE_PATH
      end

      private

      # @return [void]
      def log_table
        return if @quiet

        Debtective::Todos::PrintTable.new(@user_name).call
      end

      # @return [void]
      def filter_list!
        !@user_name.nil? && @list.todos.select! { _1.commit.author.name == @user_name }
      end

      # @return [void]
      def log_counts
        return if @quiet

        puts "total: #{@list.todos.count}"
        puts "combined lines count: #{@list.combined_count}"
        puts "extended lines count: #{@list.extended_count}"
      end

      # @return [void]
      def update_json_file
        File.open(FILE_PATH, "w") do |file|
          file.puts(
            JSON.pretty_generate(
              @list.todos.map(&:to_h)
            )
          )
        end
      end
    end
  end
end
