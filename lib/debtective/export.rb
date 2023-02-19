# frozen_string_literal: true

require "json"
require "pathname"
require "debtective/print"

module Debtective
  # Export elements in a JSON file
  class Export
    # @param user_name [String] git user email to filter
    # @param quiet [boolean]
    def initialize(user_name: nil, quiet: false)
      @user_name = user_name
      @quiet = quiet
    end

    # @return [void]
    def call
      @elements = @quiet ? find_elements : log_table
      filter_elements!
      log_counts unless @quiet
      update_json_file
      puts(FILE_PATH) unless @quiet
    end

    private

    FILE_PATH = ""

    # list of paths to search in
    # @return [Array<String>]
    def pathnames
      (Debtective.configuration&.paths || ["./**/*"])
        .flat_map { Dir[_1] }
        .map { Pathname(_1) }
        .select { _1.file? && _1.extname == ".rb" }
    end

    # select only elements commited by the given user
    # @return [void]
    def filter_elements!
      return if @user_name.nil?

      @elements.select! { _1.commit.author.name == @user_name }
    end

    # @return [void]
    def log_counts
      puts "total: #{@elements.count}"
    end

    # write elements into the JSON file
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
