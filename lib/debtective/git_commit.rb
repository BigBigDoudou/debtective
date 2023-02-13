# frozen_string_literal: true

require "git"
require "open3"

module Debtective
  # find the commit that introduced a line of code
  class GitCommit
    Author = Struct.new(:email, :name)
    Commit = Struct.new(:author, :time)

    SPECIAL_CHARACTER_REGEX = /(?!\w|\s|#|:).+/

    # @param pathname [Pathname] file path
    # @param code [String] line of code
    def initialize(pathname, code)
      @pathname = pathname
      @code = code
    end

    # @return [Debtective::GitCommit::Commit]
    def call
      Commit.new(author, time)
    rescue Git::GitExecuteError
      author = Author.new(nil, nil)
      Commit.new(author, nil)
    end

    # @return [Debtective::GitCommit::Author]
    def author
      Author.new(matches[:email], matches[:name])
    end

    # @return [Time]
    def time
      Time.parse(matches[:time])
    end

    # @return [Git::Base]
    def git
      Git.open(".")
    end

    # @return [Git::Object::Commit]
    def commit
      git.gcommit(sha)
    end

    # @return [Hash]
    def matches
      @matches ||=
        %i[sha name email time].zip(
          git_search.match(
            /^commit\s(\w{40})\nAuthor:\s(.*)\s<(.*@.*)>\nDate:\s+(.*)\n\n/
          ).to_a[1..]
        ).to_h
    end

    # @return [String]
    def git_search
      @git_search ||=
        begin
          cmd = "git log -S \"#{safe_code}\" #{@pathname}"
          ::Open3.capture3(cmd).first
        end
    end

    # commit sha
    # @return [String]
    def sha
      @sha ||=
        begin
          cmd = "git log -S \"#{safe_code}\" #{@pathname}"
          stdout, _stderr, _status = ::Open3.capture3(cmd)
          stdout[/commit (\w{40})\n/, 1]
        end
    end

    # characters " and ` can break the git command
    # @return [String]
    def safe_code
      @code.gsub(/"/, "\\\"").gsub("`", "\\\\`")
    end
  end
end
