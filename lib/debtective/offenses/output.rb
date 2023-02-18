# frozen_string_literal: true

require "json"
require "debtective/offenses/print_table"
require "debtective/offenses/find"

module Debtective
  module Offenses
    # Generate offenses list
    class Output
      FILE_PATH = "offenses.json"

      # @param user_name [String] git user email to filter
      # @param quiet [boolean]
      def initialize(user_name = nil, quiet: false)
        @user_name = user_name
        @quiet = quiet
      end

      # @return [void]
      def call
        @offenses = log_table
        @offenses ||= Debtective::Offenses::Find.new(Debtective.configuration&.paths || ["./**/*"]).call
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

        Debtective::Offenses::PrintTable.new(@user_name).call
      end

      # @return [void]
      def filter_list!
        !@user_name.nil? && @offenses.select! { _1.commit.author.name == @user_name }
      end

      # @return [void]
      def log_counts
        return if @quiet

        puts "total: #{@offenses.count}"
      end

      # @return [void]
      def update_json_file
        File.open(FILE_PATH, "w") do |file|
          file.puts(
            JSON.pretty_generate(
              @offenses.map(&:to_h)
            )
          )
        end
      end
    end
  end
end
