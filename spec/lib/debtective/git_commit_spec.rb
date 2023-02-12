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
      expect(git_commit).to be_a Git::Object::Commit
    end
  end
end
