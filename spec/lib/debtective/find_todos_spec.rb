# frozen_string_literal: true

require "debtective/find_todos"

RSpec.describe Debtective::FindTodos do
  describe "#call" do
    subject(:todos) { described_class.new(["spec/dummy/app/**/*"]).call }

    it "returns todos" do
      expect(
        todos.map { [_1.pathname.to_s, _1.todo_index, _1.boundaries] }
      ).to match_array(
        [
          ["spec/dummy/app/models/user.rb", 2, 3..20],
          ["spec/dummy/app/models/user.rb", 4, 6..8],
          ["spec/dummy/app/models/user.rb", 12, 13..18],
          ["spec/dummy/app/controllers/users_controller.rb", 3, 4..9],
          ["spec/dummy/app/controllers/users_controller.rb", 5, 5..5],
          ["spec/dummy/app/controllers/users_controller.rb", 6, 8..8]
        ]
      )
    end
  end
end
