# frozen_string_literal: true

require "debtective/end_of_statement"

RSpec.describe Debtective::EndOfStatement do
  describe "#call" do
    subject(:end_of_statement) { described_class.new(lines).call }

    context "with a class" do
      let(:index) { 0 }

      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              x + y
            end
          end
        RUBY
      end

      it "returns index before class end" do
        expect(end_of_statement).to eq 3
      end
    end

    context "with a method" do
      let(:lines) do
        <<~RUBY.split("\n")
            def foo
              x + y
            end
          end
        RUBY
      end

      it "returns index before method end" do
        expect(end_of_statement).to eq 1
      end
    end

    context "with a if statement" do
      let(:lines) do
        <<~RUBY.split("\n")
            if x + y
              do_this
            else
              do_that
            end
          end
        RUBY
      end

      it "returns index before if end" do
        expect(end_of_statement).to eq 3
      end
    end

    context "with a bloc" do
      let(:lines) do
        <<~RUBY.split("\n")
            tasks.map do |task|
              do_this(task)
            end
          end
        RUBY
      end

      it "returns index before bloc end" do
        expect(end_of_statement).to eq 1
      end
    end

    context "with a begin/rescue/ensure statement" do
      let(:lines) do
        <<~RUBY.split("\n")
            begin
              do_this
            rescue
              do_that
            ensure
              cancel
            end
          end
        RUBY
      end

      it "ignores rescue and ensure keywords" do
        expect(end_of_statement).to eq 5
      end
    end

    context "with a rescue" do
      let(:lines) do
        <<~RUBY.split("\n")
            def foo
              x + y
            rescue StandardError
              nil
            end
          end
        RUBY
      end

      it "ignores rescue keyword" do
        expect(end_of_statement).to eq 3
      end
    end

    context "with an array" do
      let(:lines) do
        <<~RUBY.split("\n")
            [
              1,
              2
            ]
          end
        RUBY
      end

      it "returns index before array closing" do
        expect(end_of_statement).to eq 2
      end
    end

    context "with an hash" do
      let(:lines) do
        <<~RUBY.split("\n")
            {
              foo: 1,
              bar: 2
            }
          end
        RUBY
      end

      it "returns index before hash closing" do
        expect(end_of_statement).to eq 2
      end
    end

    context "with conditions with carriage return" do
      let(:lines) do
        <<~RUBY.split("\n")
            foo &&
              bar ||
              baz
            x + y
          end
        RUBY
      end

      it "returns end of statement" do
        expect(end_of_statement).to eq 2
      end
    end

    context "with chaining with carriage return" do
      let(:lines) do
        <<~RUBY.split("\n")
            User
              .find(42)
              .destroy
            x + y
          end
        RUBY
      end

      it "returns end of statement" do
        expect(end_of_statement).to eq 2
      end
    end

    context "with a single line" do
      let(:lines) do
        <<~RUBY.split("\n")
            x + y
            z
          end
        RUBY
      end

      it "returns 0" do
        expect(end_of_statement).to eq 0
      end
    end
  end
end
