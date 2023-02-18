# frozen_string_literal: true

require "pathname"
require "debtective/offenses/offense"

module Debtective
  module Offenses
    # Find and investigate offense comments and return a list of offenses
    class Find
      OFFENSE_REGEX = /\s# rubocop:disable (.*)/

      # @param paths [Array<String>]
      def initialize(paths)
        @paths = paths
      end

      # @return [Array<Debtective::Offenses::Offense>]
      def call
        ruby_pathnames.flat_map { pathname_offenses(_1) }
      end

      private

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
          next unless line =~ OFFENSE_REGEX

          Debtective::Offenses::Offense.new(pathname, index, Regexp.last_match[1])
        end
      end
    end
  end
end
