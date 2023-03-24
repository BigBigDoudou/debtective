# frozen_string_literal: true

require_relative "base"

module Debtective
  module Comments
    module Comment
      # Hold shebang comment (#!) information
      class Shebang < Base
        # (see Base#comment_end)
        def comment_end
          @index
        end

        # (see Base#statement_start)
        def statement_start
          nil
        end

        # (see Base#statement_end)
        def statement_end
          nil
        end
      end
    end
  end
end
