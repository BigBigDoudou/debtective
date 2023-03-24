# frozen_string_literal: true

require_relative "comment/fixme"
require_relative "comment/magic"
require_relative "comment/note"
require_relative "comment/offense"
require_relative "comment/shebang"
require_relative "comment/todo"
require_relative "comment/yard"

module Debtective
  module Comments
    # Build proper comment type given the code line
    class BuildComment
      # Order matters, for example the Comment::Note regex matches
      # (almost) all previous regexes so it needs to be tested last
      TYPES = {
        /#\sTODO:/ => Comment::Todo,
        /#\sFIXME:/ => Comment::Fixme,
        /\s# rubocop:disable (.*)/ => Comment::Offense,
        /#\s@/ => Comment::Yard,
        /^# (frozen_string_literal|coding|encoding|warn_indent|sharable_constant_value):/ => Comment::Magic,
        /^#!/ => Comment::Shebang,
        /(^|\s)#\s/ => Comment::Note
      }.freeze

      # @param line [String] code line
      # @param pathname [Pathname] file path
      # @param index [Integer] position of the line in the file
      def initialize(line:, pathname:, index:)
        @line = line
        @pathname = pathname
        @index = index
      end

      # @return [Debtective::Comments::Base]
      def call
        klass&.new(pathname: @pathname, index: @index)
      end

      private

      def klass
        TYPES.each { |regex, klass| return klass if @line.match?(regex) }
        nil
      end
    end
  end
end
