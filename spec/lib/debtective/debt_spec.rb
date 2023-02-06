# frozen_string_literal: true

require "debtective/debt"

RSpec.describe Debtective::Debt do
  subject(:debt) { described_class.new }

  describe "#call" do
    it "returns debt lines count" do
      expect(debt.call).to eq(12 + 3 + 1)
    end
  end

  describe "#todos" do
    it "returns todos positions" do
      expect(debt.todos).to eq(
        [
          ["spec/dummy/app/models/user.rb", 4, 15],
          ["spec/dummy/app/models/user.rb", 6, 8],
          ["spec/dummy/app/models/user.rb", 13, 13]
        ]
      )
    end
  end
end
