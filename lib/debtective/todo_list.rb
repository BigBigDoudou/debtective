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
        .flat_map { Dir[_1] }
        .map { Pathname(_1) }
        .select { _1.file? && _1.extname == ".rb" }
    end
  end
end
