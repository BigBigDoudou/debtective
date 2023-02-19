# frozen_string_literal: true

require "debtective/todos/export"

RSpec.describe Debtective::Todos::Export do
  describe ".call" do
    subject(:todos_export) { described_class.new(user_name: user_name, quiet: quiet).call }

    let(:user_name) { nil }
    let(:quiet) { false }

    it "exports the todos" do
      location = "spec/dummy/app/controllers/users_controller.rb:4"
      author = "Edouard Piron"
      days = "9"
      size = "6"
      expect { todos_export }.to output(/#{location}\s+|\s#{author}\s+|\s#{days}\s+|\s#{size}\s+/).to_stdout
    end

    it "exports the counts" do
      expect { todos_export }.to output(/total: 6/).to_stdout
    end
  end
end
