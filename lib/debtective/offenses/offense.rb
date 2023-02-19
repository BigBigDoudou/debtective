# frozen_string_literal: true

require "debtective/find_commit"

module Debtective
  module Offenses
    # Hold offense information
    class Offense
      attr_accessor :pathname, :cop

      # @param pathname [Pathname]
      # @param cop [Array<String>]
      def initialize(pathname:, index:, cop:)
        @pathname = pathname
        @index = index
        @cop = cop
      end

      # location in the codebase
      # @return [String]
      def location
        "#{@pathname}:#{@index + 1}"
      end

      # return commit that introduced the offense
      # @return [Debtective::FindCommit::Commit]
      def commit
        @commit ||=
          Debtective::FindCommit.new(
            pathname: @pathname,
            code_line: @pathname.readlines[@index]
          ).call
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
          index: @index,
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
