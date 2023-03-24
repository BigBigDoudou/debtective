# frozen_string_literal: true

require_relative "base"
require_relative "../find_end_of_statement"

module Debtective
  module Comments
    module Comment
      # Hold FIXME comment information
      class Fixme < Base
        # (see Base#statement_end)
        def statement_end
          return super if inline?

          FindEndOfStatement.new(lines: lines, first_line_index: statement_start).call
        end
      end
    end
  end
end
