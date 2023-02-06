# frozen_string_literal: true

require "debtective/todos"

module Debtective
  class Debt
    def call
      todos.sum { _1[2] - _1[1] + 1 }
    end

    def todos
      @todos ||=
        ruby_file_paths
        .flat_map { Todos.new(_1).call }
        .select(&:any?)
    end

    private

    def ruby_file_paths
      paths
        .flat_map { File.extname(_1) == "" ? Dir[_1] : [_1] }
        .select { File.file?(_1) && File.extname(_1) == ".rb" }
    end

    def paths
      Debtective.configuration&.paths || []
    end
  end
end
