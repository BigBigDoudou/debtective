# frozen_string_literal: true

require "git"
require "open3"

module Debtective
  # find the commit that introduced a line of code
  class GitCommit
    # @param pathname [Pathname] file path
    # @param code [String] line of code
    def initialize(pathname, code)
      @pathname = pathname
      @code = code
    end

    # @return [Git::Object::Commit]
    def call
      git.gcommit(sha)
    end

    # @return [Git::Base]
    def git
      Git.open(".")
    end

    # commit sha
    # @return [String]
    def sha
      @sha ||=
        begin
          cmd = "git log -S \"#{@code}\" #{@pathname}"
          stdout, _stderr, _status = ::Open3.capture3(cmd)
          stdout[/commit (\w{40})\n/, 1]
        end
    end
  end
end
