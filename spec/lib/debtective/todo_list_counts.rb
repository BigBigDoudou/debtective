# frozen_string_literal: true

require "debtective/todo_list"

RSpec.describe Debtective::TodoListCounts do
  subject(:todo_list_counts) { described_class.new.call(todos) }

  let(:todos) { Debtective::TodoList.new.call }

  describe "extended_count" do
    it "returns the sum of todo blocks" do
      expect(todo_list_counts.extended_count).to eq 34
    end
  end

  describe "combined_count" do
    it "returns the sum of todo blocks excluding overlaps" do
      expect(todo_list_counts.combined_count).to eq 24
    end
  end
end
