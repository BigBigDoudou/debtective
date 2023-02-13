# frozen_string_literal: true

require "debtective/todos_counts"
require "debtective/find_todos"

RSpec.describe Debtective::TodosCounts do
  subject(:todos_counts) do
    described_class.new(
      [
        Debtective::Todo.new("foo.rb", 1, 2..10, nil),
        Debtective::Todo.new("foo.rb", 4, 5..7, nil),
        Debtective::Todo.new("bar.rb", 3, 3..3, nil)
      ]
    )
  end

  describe "extended_count" do
    it "returns the sum of todo blocks" do
      expect(todos_counts.extended_count).to eq 9 + 3 + 1
    end
  end

  describe "combined_count" do
    it "returns the sum of todo blocks excluding overlaps" do
      expect(todos_counts.combined_count).to eq 9 + 1
    end
  end
end
