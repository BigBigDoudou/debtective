# frozen_string_literal: true

require_relative "../find_commit"

module Debtective
  module Comments
    module Comment
      # Hold comment information
      class Base
        # Does not match YARD or shebang comments
        REGULAR_COMMENT = /^\s*#\s(?!@)/

        attr_accessor :pathname

        # @param pathname [Pathname] path of the file
        # @param index [Integer] position of the comment in the file
        def initialize(pathname:, index:)
          @pathname = pathname
          @index = index
        end

        # @return [String]
        def type
          self.class.name.split("::").last.downcase
        end

        # @return [Integer]
        def comment_start
          @index
        end

        # @return [Integer]
        def comment_end
          @comment_end ||= last_following_comment_index || comment_start
        end

        # @return [Integer]
        def statement_start
          @statement_start ||= inline? ? @index : comment_end.next
        end

        # @return [Integer]
        def statement_end
          statement_start
        end

        # Location in the codebase (for clickable link)
        # @return [String]
        def location
          "#{@pathname.to_s.gsub(%r{^./}, "")}:#{comment_start + 1}"
        end

        # Return commit that introduced the todo
        # @return [Debtective::Comments::FindCommit::Commit]
        def commit
          @commit ||= FindCommit.new(pathname: @pathname, line: lines[@index]).call
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
            type: type,
            comment_boundaries: [comment_start, comment_end],
            statement_boundaries: [statement_start, statement_end],
            commit: commit.sha,
            author: commit.author.to_h,
            time: commit.time
          }
        end

        private

        def lines
          @lines ||= @pathname.readlines
        end

        def inline?
          @inline ||= !lines[@index].match?(/^\s*#/)
        end

        def last_following_comment_index
          if inline?
            @index
          else
            lines.index.with_index do |line, i|
              i > @index &&
                !line.strip.empty? &&
                !line.match?(REGULAR_COMMENT)
            end&.-(1)
          end
        end
      end
    end
  end
end
