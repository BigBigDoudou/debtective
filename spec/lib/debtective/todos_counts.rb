# frozen_string_literal: true

require "debtective/todos_counts"
require "debtective/todos_builder"

RSpec.describe Debtective::TodosCounts do
  subject(:todos_counts) { described_class.new.call(todos) }

  let(:todos) { Debtective::TodosBuilder.new.call }

  describe "extended_count" do
    it "returns the sum of todo blocks" do
      expect(todos_counts.extended_count).to eq 34
    end
  end

  describe "combined_count" do
    it "returns the sum of todo blocks excluding overlaps" do
      expect(todos_counts.combined_count).to eq 24
    end
  end
end
