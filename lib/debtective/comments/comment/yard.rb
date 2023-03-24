# frozen_string_literal: true

require_relative "base"
require_relative "../find_end_of_statement"

module Debtective
  module Comments
    module Comment
      # Hold YARD comment information
      class Yard < Base
        # (see Base#comment_end)
        def comment_end
          @index
        end

        # (see Base#statement_start)
        def statement_start
          last_following_comment_index.next
        end

        # (see Base#statement_end)
        def statement_end
          FindEndOfStatement.new(lines: lines, first_line_index: statement_start).call
        end
      end
    end
  end
end
