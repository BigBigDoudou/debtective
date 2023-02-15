# frozen_string_literal: true

require "debtective/git_commit"
require "pry"

module Debtective
  # Hold todo information
  class Todo
    class << self
      # @return [Debtective::Todo]
      def build(pathname, index)
        BuildTodo.new(pathname, index).call
      end
    end

    attr_accessor :pathname, :todo_index, :boundaries, :commit

    # @param pathname [Pathname]
    # @param todo_index [Integer] first line of todo comment
    # @param boundaries [Range] first and last index of the concerned code
    # @param commit [Debtective::GitCommit::Commit] commit that introduced the todo
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

    # @return [Integer]
    def days
      return if commit.time.nil?

      ((Time.now - commit.time) / (24 * 60 * 60)).round
    end

    # @return [Hash]
    def to_h
      {
        pathname: pathname,
        location: location,
        line_numbers: line_numbers.to_a,
        size: size,
        commit: {
          sha: commit.sha,
          author: commit.author.to_h,
          time: commit.time.to_s
        }
      }
    end
  end
end
