# frozen_string_literal: true

require "debtective/build_todo"

module Debtective
  # Find and investigate todo comments and return a list of todos
  class FindTodos
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
        next unless line.match?(TODO_REGEX)

        Todo.build(pathname, index)
      end
    end
  end
end
