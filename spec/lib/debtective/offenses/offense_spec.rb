# frozen_string_literal: true

require "debtective/offenses/offense"

RSpec.describe Debtective::Offenses::Offense do
  subject(:offenses_offense) do
    described_class.new(
      pathname: pathname,
      index: 2,
      cop: "Layout/ExtraSpacing"
    )
  end

  let(:pathname) do
    instance_double(
      Pathname,
      readlines: ["", "", "1 + 1 # rubocop:disable Layout/ExtraSpacing"],
      to_s: "foo.rb"
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
      .with(pathname: pathname, code_line: "1 + 1 # rubocop:disable Layout/ExtraSpacing")
      .and_return(commit)
  end

  describe "#location" do
    it "returns the location in the codebase" do
      expect(offenses_offense.location).to eq "foo.rb:3"
    end
  end

  describe "#days" do
    it "returns number of days since offense has been written" do
      expect(offenses_offense.days).to be_an Integer
    end
  end

  describe "#to_h" do
    it "returns an hash with offense information" do
      expect(offenses_offense.to_h).to eq(
        {
          commit: {
            author: {
              email: "jane.doe@mail.com",
              name: "Jane Doe"
            },
            sha: "1234",
            time: Time.parse("2000-01-01 00:00:00 +0100")
          },
          location: "foo.rb:3",
          pathname: pathname,
          index: 2
        }
      )
    end
  end
end
