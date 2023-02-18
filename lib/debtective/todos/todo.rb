# frozen_string_literal: true

require "debtective/find_commit"

module Debtective
  module Todos
    # Hold todo information
    class Todo
      attr_accessor :pathname, :todo_boundaries, :statement_boundaries

      # @param pathname [Pathname]
      # @param lines [Array<String>]
      # @param todo_boundaries [Range]
      # @param statement_boundaries [Range]
      def initialize(pathname, lines, todo_boundaries, statement_boundaries)
        @pathname = pathname
        @lines = lines
        @todo_boundaries = todo_boundaries
        @statement_boundaries = statement_boundaries
      end

      # location in the codebase
      # @return [String]
      def location
        "#{@pathname}:#{@todo_boundaries.min + 1}"
      end

      # size of the todo code
      # @return [Integer]
      def size
        @statement_boundaries.size
      end

      # return commit that introduced the todo
      # @return [Git::Object::Commit]
      def commit
        @commit ||= Debtective::FindCommit.new(@pathname, @lines[@todo_boundaries.min]).call
      end

      # @return [Integer]
      def days
        return if commit.time.nil?

        ((Time.now - commit.time) / (24 * 60 * 60)).round
      end

      # @return [Hash]
      def to_h
        {
          pathname: @pathname,
          location: location,
          todo_boundaries: todo_boundaries.minmax,
          statement_boundaries: statement_boundaries.minmax,
          size: size,
          commit: {
            sha: commit.sha,
            author: commit.author.to_h,
            time: commit.time
          }
        }
      end
    end
  end
end
