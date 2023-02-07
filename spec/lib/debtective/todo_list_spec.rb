# frozen_string_literal: true

require "debtective/todo_list"

RSpec.describe Debtective::TodoList do
  describe "#call" do
    subject(:todo_list) { described_class.new.call }

    it "returns a todo_list" do
      expect(todo_list).to respond_to(
        :todos,
        :extended_count,
        :combined_count
      )
    end

    describe "todos" do
      it "returns todos information" do
        expect(
          todo_list.todos.map { [_1.pathname.to_s, _1.boundaries] }
        ).to match_array(
          [
            ["spec/dummy/app/models/user.rb", 4..19],
            ["spec/dummy/app/models/user.rb", 6..7],
            ["spec/dummy/app/models/user.rb", 13..17],
            ["spec/dummy/app/controllers/users_controller.rb", 5..8],
            ["spec/dummy/app/controllers/users_controller.rb", 8..8]
          ]
        )
      end
    end

    describe "extended_count" do
      it "returns the sum of todo blocks" do
        expect(todo_list.extended_count).to eq 28
      end
    end

    describe "combined_count" do
      it "returns the sum of todo blocks excluding overlaps" do
        expect(todo_list.combined_count).to eq 20
      end
    end
  end
end
