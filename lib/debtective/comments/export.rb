# frozen_string_literal: true

require "pathname"
require "json"
require "parser/current"
require_relative "../stderr_helper"
require_relative "build_comment"
require_relative "print"

module Debtective
  module Comments
    # Export comments in a JSON file and to stdout
    class Export
      include StderrHelper

      OPTIONS = {
        user_name: nil,
        quiet: false,
        included_types: [],
        excluded_types: [],
        included_paths: [],
        excluded_paths: []
      }.freeze

      FILE_PATH = "comments.json"

      # @param user_name [String] git user email to filter
      # @param quiet [boolean]
      # @param included_types [Array<String>] types of comment to export
      # @param excluded_types [Array<String>] types of comment to skip
      # @param included_paths [Array<String>] paths to explore
      # @param excluded_paths [Array<String>] paths to skip
      def initialize(**options)
        OPTIONS.each do |key, default|
          instance_variable_set(:"@#{key}", options[key] || default)
        end
      end

      # @return [void]
      def call
        # suppress_stderr prevents stderr outputs from compilations
        suppress_stderr do
          @comments = @quiet ? find_comments : log_table
        end
        filter_comments!
        log_counts unless @quiet
        write_json_file
        puts(FILE_PATH) unless @quiet
      end

      private

      def find_comments
        pathnames.flat_map do |pathname|
          last_comment_found = nil
          pathname.readlines.filter_map.with_index do |line, index|
            next if last_comment_found && index < last_comment_found.comment_end.next
            next unless comment?(line)

            comment = BuildComment.new(line: line, pathname: pathname, index: index).call
            next if comment.nil?

            last_comment_found = comment
            export_comment(comment)
          end
        end
      end

      def comment?(line)
        return true if line =~ /^\s*#(\s|!)/
        return false unless line =~ /\s(#\s.*)/

        # Ensure it is really a comment to avoid something like
        # puts("hello # world")
        # to be considered as an inline comment
        !Parser::CurrentRuby.parse(line).to_s.include?(Regexp.last_match[1])
      rescue Parser::SyntaxError
        false
      end

      # Export the comment if asked so by the user
      # @return [Debtective::Comments::Comment::Base, nil]
      # @note This method is watched by Print class to log in stdout
      def export_comment(comment)
        if @included_types.include?(comment.type) ||
           (@included_types.empty? && !@excluded_types.include?(comment.type))

          comment
        end
      end

      def log_table
        Print.new(user_name: @user_name).call { find_comments }
      end

      # List of paths to search in
      def pathnames
        Dir["./**/*"]
          .map { Pathname(_1) }
          .select { _1.file? && _1.extname == ".rb" && explore?(_1) }
      end

      def explore?(path)
        return false if @excluded_paths.any? { path.to_s.gsub(%r{^./}, "").match?(/^#{_1}/) }
        return true if @included_paths.empty?

        @included_paths.any? { path.to_s.gsub(%r{^./}, "").match?(/^#{_1}/) }
      end

      # Select comments committed by the user
      def filter_comments!
        return if @user_name.nil?

        @comments.select! { _1.commit.author.name == @user_name }
      end

      def log_counts
        puts "total: #{@comments.count}"
      end

      def write_json_file
        File.open(self.class::FILE_PATH, "w") do |file|
          file.puts(
            JSON.pretty_generate(
              @comments.map(&:to_h)
            )
          )
        end
      end
    end
  end
end
