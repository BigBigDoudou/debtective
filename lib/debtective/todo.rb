# frozen_string_literal: true

require "debtective/git_commit"

module Debtective
  # Hold todo information
  class Todo
    Author = Struct.new(:email, :name)
    Commit = Struct.new(:author, :date)

    attr_accessor :pathname, :todo_index, :boundaries, :commit

    # @param pathname [Pathname]
    # @param todo_index [Integer] first line of todo comment
    # @param boundaries [Range] first and last index of the concerned code
    # @param commit [Git::Object::Commit] commit that introduced the todo
    def initialize(pathname, todo_index, boundaries, commit)
      @pathname = pathname
      @todo_index = todo_index
      @boundaries = boundaries
      @commit = commit
    end

    # location in the codebase
    # @return [String]
    def location
      "#{@pathname}:#{@todo_index + 1}"
    end

    # size of the todo code
    # @return [Integer]
    def size
      boundaries.size
    end

    # line numbers (as displayed in an IDE)
    # @return [Range]
    def line_numbers
      (boundaries.min + 1)..(boundaries.max + 1)
    end
  end
end
