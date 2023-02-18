# frozen_string_literal: true

require "git"
require "open3"

module Debtective
  # find the commit that introduced a line of code
  class FindCommit
    Author = Struct.new(:email, :name)
    Commit = Struct.new(:sha, :author, :time)

    SPECIAL_CHARACTER_REGEX = /(?!\w|\s|#|:).+/

    # @param pathname [Pathname] file path
    # @param code [String] line of code
    def initialize(pathname, code)
      @pathname = pathname
      @code = code
    end

    # @return [Debtective::FindCommit::Commit]
    def call
      Commit.new(sha, author, time)
    rescue Git::GitExecuteError
      author = Author.new(nil, nil)
      Commit.new(nil, author, nil)
    end

    # @return [Debtective::FindCommit::Author]
    def author
      Author.new(commit.author.email, commit.author.name)
    end

    # @return [Time]
    def time
      commit.date
    end

    # @return [Git::Base]
    def git
      Git.open(".")
    end

    # @return [Git::Object::Commit]
    def commit
      git.gcommit(sha)
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