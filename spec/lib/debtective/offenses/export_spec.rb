# frozen_string_literal: true

require "debtective/offenses/export"

RSpec.describe Debtective::Offenses::Export do
  describe ".call" do
    subject(:offenses_export) { described_class.new(user_name: user_name, quiet: quiet).call }

    let(:user_name) { "Edouard Piron" }
    let(:quiet) { false }

    it "exports the offenses" do
      location = "spec/dummy/app/controllers/users_controller.rb:9"
      author = "Edouard Piron"
      cop = "Layout/ExtraSpacing"
      expect { offenses_export }.to output(/#{location}\s+|\s#{author}\s+|\s#{cop}/).to_stdout
    end

    it "exports the counts" do
      expect { offenses_export }.to output(/total: 4/).to_stdout
    end
  end
end
