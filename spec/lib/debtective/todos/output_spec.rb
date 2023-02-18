# frozen_string_literal: true

require "debtective/todos/output"

RSpec.describe Debtective::Todos::Output do
  describe ".call" do
    subject(:todos_output) { described_class.new(user_name, quiet: quiet).call }

    let(:user_name) { nil }
    let(:quiet) { false }

    it "outputs the todos" do
      location = "spec/dummy/app/controllers/users_controller.rb:4"
      author = "Edouard Piron"
      days = "9"
      size = "6"
      expect { todos_output }.to output(/#{location}\s+|\s#{author}\s+|\s#{days}\s+|\s#{size}\s+/).to_stdout
    end

    it "outputs the counts" do
      expect { todos_output }.to output(/total: 6/).to_stdout
    end
  end
end
