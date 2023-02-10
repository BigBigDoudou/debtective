# frozen_string_literal: true

require "debtective/file_todos"

module Debtective
  # Find and investigate todo comments
  class TodoList
    DEFAULT_PATHS = ["./**/*"].freeze

    # @return [Array<FileTodos::Result>]
    def call
      ruby_pathnames
        .flat_map { FileTodos.new(_1).call }
    end

    private

    # @return [Array<String>]
    def paths
      Debtective.configuration&.paths || DEFAULT_PATHS
    end

    # @return [Array<Pathname>] only pathes to ruby files
    def ruby_pathnames
      paths
        .flat_map { File.extname(_1) == "" ? Dir[_1] : [_1] }
        .map { Pathname(_1) }
        .select { _1.file? && _1.extname == ".rb" }
    end

    # @return [Integer]
    def extended_count
      todos
        .sum { _1.boundaries.size }
    end

    # @return [Integer]
    def combined_count
      todos
        .group_by(&:pathname)
        .values
        .sum do |file_todos|
          file_todos
            .map { _1.boundaries.to_a }
            .reduce(:|)
            .length
        end
    end
  end
end
