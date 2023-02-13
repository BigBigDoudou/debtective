# frozen_string_literal: true

require "debtective/todo"

RSpec.describe Debtective::GitCommit do
  describe "#call" do
    subject(:git_commit) do
      described_class.new(
        "spec/dummy/app/models/user.rb",
        "# TODO: use an STI"
      ).call
    end

    it "returns commit that introduced the code" do
      expect(git_commit.datetime).to eq Time.parse("2023-02-06 22:54:14.000000000 +0100")
      expect(git_commit.author.name).to eq "Edouard Piron"
      expect(git_commit.author.email).to eq "ed.piron@gmail.com"
    end
  end
end
