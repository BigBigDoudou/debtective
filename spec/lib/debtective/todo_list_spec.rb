# frozen_string_literal: true

require "debtective/todo_list"

RSpec.describe Debtective::TodoList do
  describe "#call" do
    subject(:todo_list) { described_class.new.call }

    it "returns todos" do
      expect(
        todo_list.map { [_1.pathname.to_s, _1.todo_index, _1.boundaries] }
      ).to match_array(
        [
          ["spec/dummy/app/models/user.rb", 2, 3..20],
          ["spec/dummy/app/models/user.rb", 4, 6..8],
          ["spec/dummy/app/models/user.rb", 12, 13..18],
          ["spec/dummy/app/controllers/users_controller.rb", 3, 4..9],
          ["spec/dummy/app/controllers/users_controller.rb", 6, 8..8]
        ]
      )
    end

    # describe "extended_count" do
    #   it "returns the sum of todo blocks" do
    #     expect(todo_list.extended_count).to eq 34
    #   end
    # end

    # describe "combined_count" do
    #   it "returns the sum of todo blocks excluding overlaps" do
    #     expect(todo_list.combined_count).to eq 24
    #   end
    # end
  end
end
