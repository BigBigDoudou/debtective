# frozen_string_literal: true

require "git"
require "open3"

module Debtective
  module Comments
    # Find the commit that introduced the given line of code
    class FindCommit
      Author = Struct.new(:email, :name)
      Commit = Struct.new(:sha, :author, :time)

      # @param pathname [Pathname] file path
      # @param line [String] line of code
      def initialize(pathname:, line:)
        @pathname = pathname
        @line = line
      end

      # @return [Debtective::Comments::FindCommit::Commit]
      def call
        Commit.new(sha, author, time)
      rescue Git::GitExecuteError
        author = Author.new(nil, nil)
        Commit.new(nil, author, nil)
      end

      # @return [Debtective::Comments::FindCommit::Author]
      def author
        Author.new(commit.author.email, commit.author.name)
      end

      # @return [Time]
      def time
        commit.date
      end

      # @return [String]
      def sha
        @sha ||=
          begin
            cmd = "git log -S \"#{safe_code}\" #{@pathname}"
            stdout, _stderr, _status = ::Open3.capture3(cmd)
            stdout[/commit (\w{40})\n/, 1]
          end
      end

      private

      # @return [Git::Base]
      def git
        Git.open(".")
      end

      # @return [Git::Object::Commit]
      def commit
        git.gcommit(sha)
      end

      # Characters " and ` can break the git command
      def safe_code
        @line.gsub(/"/, "\\\"").gsub("`", "\\\\`")
      end
    end
  end
end
