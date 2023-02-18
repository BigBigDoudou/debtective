# frozen_string_literal: true

require "debtective/find"
require "debtective/offenses/offense"

module Debtective
  module Offenses
    # Find offenses
    class Find < Debtective::Find
      REGEX = /\s# rubocop:disable (.*)/

      def build(pathname, index, match)
        Debtective::Offenses::Offense.new(pathname, index, match[1])
      end
    end
  end
end
