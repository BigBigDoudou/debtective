# frozen_string_literal: true

require "debtective/find"
require "debtective/todos/build"

module Debtective
  module Todos
    # Find TODO comments
    class Find < Debtective::Find
      REGEX = /#\sTODO:/

      def build(pathname, index, _match)
        Debtective::Todos::Build.new(pathname, index).call
      end
    end
  end
end
