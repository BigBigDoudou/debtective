# frozen_string_literal: true

require "pathname"
require "debtective/todos/build"

module Debtective
  module Todos
    # Find and investigate todo comments and return a list of todos
    class Find
      TODO_REGEX = /#\sTODO:/

      # @param paths [Array<String>]
      def initialize(paths)
        @paths = paths
      end

      # @return [Array<Debtective::Todos::Todo>]
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
      # @return [Array<Debtective::Todos::Todo>]
      def pathname_todos(pathname)
        pathname.readlines.filter_map.with_index do |line, index|
          next unless line.match?(TODO_REGEX)

          Debtective::Todos::Todo.build(pathname, index)
        end
      end
    end
  end
end
