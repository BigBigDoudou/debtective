# frozen_string_literal: true

require "debtective/comments/export"

RSpec.describe Debtective::Comments::Export do
  subject(:export) do
    described_class.new(
      user_name: user_name,
      quiet: quiet,
      included_types: included_types,
      excluded_types: excluded_types,
      included_paths: ["spec/dummy/app/**/*"]
    )
  end

  let(:user_name) { "Edouard Piron" }
  let(:quiet) { false }
  let(:included_types) { [] }
  let(:excluded_types) { [] }

  describe ".call" do
    it "exports the comments" do
      expect { export.call }.to output(
        %r{
          spec/dummy/app/controllers/application_controller.rb:1 \s+| comment \s+| Edouard Piron \s+\n*
          spec/dummy/app/controllers/users_controller.rb:4       \s+| todo    \s+| Edouard Piron \s+\n*
          spec/dummy/app/models/application_record.rb:4          \s+| offense \s+| Edouard Piron \s+\n*
        }
      ).to_stdout
    end

    it "exports the counts" do
      expect { export.call }.to output(/total: 15/).to_stdout
    end

    context "when including todo" do
      let(:included_types) { ["todo"] }

      it "exports only the todo comments" do
        expect { export.call }.to output(/todo/).to_stdout
        expect { export.call }.not_to output(/offense/).to_stdout
        expect { export.call }.not_to output(/note/).to_stdout
      end
    end

    context "when excluding todo" do
      let(:excluded_types) { ["todo"] }

      it "exports everything except the todo comments" do
        expect { export.call }.not_to output(/todo/).to_stdout
        expect { export.call }.to output(/offense/).to_stdout
        expect { export.call }.to output(/note/).to_stdout
      end
    end
  end
end
