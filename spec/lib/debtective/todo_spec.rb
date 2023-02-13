# frozen_string_literal: true

require "debtective/todo"

RSpec.describe Debtective::Todo do
  describe "#call" do
    subject(:todo) do
      described_class.new(
        "foo.rb",
        42,
        43..45,
        Debtective::GitCommit::Commit.new(
          "1234",
          Debtective::GitCommit::Author.new(
            "jane.doe@mail.com",
            "Jane Doe"
          ),
          Time.new(2000)
        )
      )
    end

    describe "#location" do
      it "returns the location in the codebase" do
        expect(todo.location).to eq "foo.rb:43"
      end
    end

    describe "#size" do
      it "returns the size (lines count) of code concerned by the todo" do
        expect(todo.size).to eq 3
      end
    end

    describe "#line_numbers" do
      it "returns the numbers of the first and last lines" do
        expect(todo.line_numbers).to eq 44..46
      end
    end

    describe "#to_h" do
      it "returns an hash with todo information" do
        expect(todo.to_h).to eq(
          {
            commit: {
              author: {
                email: "jane.doe@mail.com",
                name: "Jane Doe"
              },
              sha: "1234",
              time: "2000-01-01 00:00:00 +0100"
            },
            line_numbers: [44, 45, 46],
            location: "foo.rb:43",
            pathname: "foo.rb",
            size: 3
          }
        )
      end
    end
  end
end
