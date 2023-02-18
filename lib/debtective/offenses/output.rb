# frozen_string_literal: true

require "debtective/output"
require "debtective/offenses/print_table"
require "debtective/offenses/find"

module Debtective
  module Offenses
    # Output offenses
    class Output < Debtective::Output
      private

      FILE_PATH = "offenses.json"

      # @return [void]
      def log_table
        Debtective::Offenses::PrintTable.new(@user_name).call
      end

      # @return [Array<Debtective::Offenses::Offense>]
      def find_offenses
        Debtective::Offenses::Find.new(paths).call
      end
    end
  end
end
