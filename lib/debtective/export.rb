# frozen_string_literal: true

require "json"
require "debtective/print"

module Debtective
  class Export
    # @param user_name [String] git user email to filter
    # @param quiet [boolean]
    def initialize(user_name = nil, quiet: false)
      @user_name = user_name
      @quiet = quiet
    end

    # @return [void]
    def call
      log_table unless @quiet
      @elements ||= find_elements
      filter_elements!
      log_counts unless @quiet
      update_json_file
      puts(FILE_PATH) unless @quiet
    end

    private

    FILE_PATH = ""

    def paths
      Debtective.configuration&.paths || ["./**/*"]
    end

    # @return [void]
    def filter_elements!
      !@user_name.nil? && @elements.select! { _1.commit.author.name == @user_name }
    end

    # @return [void]
    def log_counts
      puts "total: #{@elements.count}"
    end

    # @return [void]
    def update_json_file
      File.open(self.class::FILE_PATH, "w") do |file|
        file.puts(
          JSON.pretty_generate(
            @elements.map(&:to_h)
          )
        )
      end
    end
  end
end
