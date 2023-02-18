# frozen_string_literal: true

require "pathname"

module Debtective
  # Find in the codebase
  class Find
    # @param paths [Array<String>]
    def initialize(paths)
      @paths = paths
    end

    # @return [Array<Debtective::Offenses::Offense>]
    def call
      ruby_pathnames.flat_map { pathname_offenses(_1) }
    end

    private

    REGEX = //

    # @return [Array<Pathname>] only pathes to ruby files
    def ruby_pathnames
      @paths
        .flat_map { Dir[_1] }
        .map { Pathname(_1) }
        .select { _1.file? && _1.extname == ".rb" }
    end

    # return offenses in the pathname
    # @return [Array<Debtective::Offenses::Offense>]
    def pathname_offenses(pathname)
      pathname.readlines.filter_map.with_index do |line, index|
        next unless line =~ self.class::REGEX

        build(pathname, index, Regexp.last_match)
      end
    end
  end
end
