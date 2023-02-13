# frozen_string_literal: true

require "debtective/todo"

RSpec.describe Debtective::Todo do
  describe "#call" do
    subject(:todo) { described_class.new("foo.rb", 42, 43..45, nil) }

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
  end
end
