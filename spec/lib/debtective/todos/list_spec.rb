# frozen_string_literal: true

require "debtective/todos/list"

RSpec.describe Debtective::Todos::List do
  describe "#call" do
    subject(:todos_list) { described_class.new(["spec/dummy/app/**/*"]) }

    describe "#todos" do
      it "returns the location in the codebase" do
        expect(
          todos_list.todos.map do |todo|
            [
              todo.pathname.to_s,
              todo.todo_boundaries,
              todo.statement_boundaries,
              todo.commit.author.name,
              todo.commit.time.strftime("%F")
            ]
          end
        ).to eq(
          [
            ["spec/dummy/app/controllers/users_controller.rb", 3..3, 4..9, "Edouard Piron", "2023-02-07"],
            ["spec/dummy/app/controllers/users_controller.rb", 5..5, 5..5, "Edouard Piron", "2023-02-11"],
            ["spec/dummy/app/controllers/users_controller.rb", 6..7, 8..8, "Edouard Piron", "2023-02-07"],
            ["spec/dummy/app/models/user.rb", 2..2, 3..20, "Edouard Piron", "2023-02-06"],
            ["spec/dummy/app/models/user.rb", 4..5, 6..8, "Edouard Piron", "2023-02-06"],
            ["spec/dummy/app/models/user.rb", 12..12, 13..18, "Edouard Piron", "2023-02-06"]
          ]
        )
      end
    end

    describe "#authors" do
      it "returns the location in the codebase" do
        expect(
          todos_list.authors.map do |author|
            [
              author.name,
              author.email,
              author.todos.map do |todo|
                [
                  todo.pathname.to_s,
                  todo.todo_boundaries.min
                ]
              end
            ]
          end
        ).to eq(
          [
            [
              "Edouard Piron",
              "ed.piron@gmail.com",
              [
                ["spec/dummy/app/controllers/users_controller.rb", 3],
                ["spec/dummy/app/controllers/users_controller.rb", 5],
                ["spec/dummy/app/controllers/users_controller.rb", 6],
                ["spec/dummy/app/models/user.rb", 2],
                ["spec/dummy/app/models/user.rb", 4],
                ["spec/dummy/app/models/user.rb", 12]
              ]
            ]
          ]
        )
      end
    end

    describe "extended_count" do
      it "returns the sum of todo blocks" do
        expect(todos_list.extended_count).to eq 35
      end
    end

    describe "combined_count" do
      it "returns the sum of todo blocks excluding overlaps" do
        expect(todos_list.combined_count).to eq 24
      end
    end
  end
end
