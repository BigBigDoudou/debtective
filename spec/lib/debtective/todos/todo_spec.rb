# frozen_string_literal: true

require "debtective/todos/todo"

RSpec.describe Debtective::Todos::Todo do
  subject(:todos_todo) do
    described_class.new(
      "foo.rb",
      Array.new(42, "") + ["#TODO: do that", "def example", "  x + y", "end"],
      42..42,
      43..45
    )
  end

  let(:commit) do
    instance_double(
      Debtective::FindCommit,
      call: Debtective::FindCommit::Commit.new(
        "1234",
        Debtective::FindCommit::Author.new("jane.doe@mail.com", "Jane Doe"),
        Time.new(2000)
      )
    )
  end

  before do
    allow(Debtective::FindCommit)
      .to receive(:new)
      .with("foo.rb", "#TODO: do that")
      .and_return(commit)
  end

  describe "#location" do
    it "returns the location in the codebase" do
      expect(todos_todo.location).to eq "foo.rb:43"
    end
  end

  describe "#size" do
    it "returns the size (lines count) of code concerned by the todo" do
      expect(todos_todo.size).to eq 3
    end
  end

  describe "#days" do
    it "returns number of days since todo has been written" do
      expect(todos_todo.days).to be_an Integer
    end
  end

  describe "#to_h" do
    it "returns an hash with todo information" do
      expect(todos_todo.to_h).to eq(
        {
          commit: {
            author: {
              email: "jane.doe@mail.com",
              name: "Jane Doe"
            },
            sha: "1234",
            time: Time.parse("2000-01-01 00:00:00 +0100")
          },
          todo_boundaries: [42, 42],
          statement_boundaries: [43, 45],
          location: "foo.rb:43",
          pathname: "foo.rb",
          size: 3
        }
      )
    end
  end
end
