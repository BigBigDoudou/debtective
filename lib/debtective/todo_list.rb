# frozen_string_literal: true

require "debtective/todo_builder"

module Debtective
  # Find and investigate todo comments
  class TodoList
    TODO_REGEX = /#\sTODO:/

    # @param paths [Array<String>]
    def initialize(paths)
      @paths = paths
    end

    # @return [Array<Debtective::Todo>]
    def call
      ruby_pathnames.flat_map { pathname_todos(_1) }
    end

    private

    # @return [Array<Pathname>] only pathes to ruby files
    def ruby_pathnames
      @paths
        .flat_map { Dir[_1] }
        .map { Pathname(_1) }
        .select { _1.file? && _1.extname == ".rb" }
    end

    # return todos in the pathname
    # @return [Array<Debtective::Todo>]
    def pathname_todos(pathname)
      pathname.readlines.filter_map.with_index do |line, index|
        TodoBuilder.new(pathname, index).call if line.match?(TODO_REGEX)
      end
    end
  end
end
