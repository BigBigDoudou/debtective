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
      expect(git_commit.time).to eq Time.parse("2023-02-06 22:54:14.000000000 +0100")
      expect(git_commit.author.name).to eq "Edouard Piron"
      expect(git_commit.author.email).to eq "ed.piron@gmail.com"
    end

    context "when commit cannot be found" do
      before do
        allow(Open3).to receive(:capture3).and_raise(Git::GitExecuteError)
      end

      it "returns a null commit" do
        expect(git_commit.time).to be_nil
        expect(git_commit.author.name).to be_nil
        expect(git_commit.author.email).to be_nil
      end
    end
  end
end
