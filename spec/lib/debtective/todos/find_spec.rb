# frozen_string_literal: true

require "debtective/todos/find"

RSpec.describe Debtective::Todos::Find do
  describe "#call" do
    subject(:todos_find) { described_class.new(["spec/dummy/app/**/*"]).call }

    it "returns todos" do
      expect(
        todos_find.map { [_1.pathname.to_s, _1.todo_boundaries, _1.statement_boundaries] }
      ).to match_array(
        [
          ["spec/dummy/app/models/user.rb", 2..2, 3..20],
          ["spec/dummy/app/models/user.rb", 4..5, 6..8],
          ["spec/dummy/app/models/user.rb", 12..12, 13..18],
          ["spec/dummy/app/controllers/users_controller.rb", 3..3, 4..9],
          ["spec/dummy/app/controllers/users_controller.rb", 5..5, 5..5],
          ["spec/dummy/app/controllers/users_controller.rb", 6..7, 8..8]
        ]
      )
    end
  end
end