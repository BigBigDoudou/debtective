# frozen_string_literal: true

require "debtective/comments/find_commit"

RSpec.describe Debtective::Comments::FindCommit do
  subject(:find_commit) do
    described_class.new(
      pathname: "spec/dummy/app/models/user.rb",
      line: "# TODO: use an STI"
    )
  end

  describe "#call" do
    it "returns commit that introduced the code" do
      expect(find_commit.call.time).to eq Time.parse("2023-02-06 22:54:14.000000000 +0100")
      expect(find_commit.call.author.name).to eq "Edouard Piron"
      expect(find_commit.call.author.email).to eq "ed.piron@gmail.com"
    end

    context "when commit cannot be found" do
      before do
        allow(Open3).to receive(:capture3).and_raise(Git::GitExecuteError)
      end

      it "returns a null commit" do
        expect(find_commit.call.time).to be_nil
        expect(find_commit.call.author.name).to be_nil
        expect(find_commit.call.author.email).to be_nil
      end
    end
  end
end
