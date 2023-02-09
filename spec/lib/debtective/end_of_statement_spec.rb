# frozen_string_literal: true

require "debtective/end_of_statement"

RSpec.describe Debtective::EndOfStatement do
  describe "#call" do
    context "with a class" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              x + y
            end
          end
        RUBY
      end

      it "returns index of class end" do
        expect(described_class.new(lines, 0).call).to eq 4
      end
    end

    context "with a method" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              do_this
              do_that
            end

            def bar
              do_this
            rescue StandardError
              do_that
            end
          end
        RUBY
      end

      it "returns index of method end" do
        expect(described_class.new(lines, 1).call).to eq 4
        expect(described_class.new(lines, 6).call).to eq 10
      end
    end

    context "with a condition statement" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              if x + y
                do_this
              else
                do_that
              end
            end

            def bar
              var = unless x
                42
              end
            end
          end
        RUBY
      end

      it "returns index of block end" do
        expect(described_class.new(lines, 2).call).to eq 6
        expect(described_class.new(lines, 10).call).to eq 12
      end
    end

    context "with a bloc" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              tasks.map do |task|
                task.done?
              end

              x = tasks.each {
                _1.done?
              }

              tasks.map { _1.duration }
                .sum
                .to_s +
                  'hello world'
            end
          end
        RUBY
      end

      it "returns index of statement end" do
        expect(described_class.new(lines, 2).call).to eq 4
        expect(described_class.new(lines, 6).call).to eq 8
        expect(described_class.new(lines, 10).call).to eq 13
      end
    end

    context "with a begin/rescue/ensure" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              begin
                do_this
              rescue
                do_that
              ensure
                close
              end
            end
          end
        RUBY
      end

      it "returns index of statement end" do
        expect(described_class.new(lines, 2).call).to eq 8
      end
    end

    context "with an array or an hash" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              tasks = [
                x,
                y
              ]

              projects = {
                x: 1,
                y: 2
              }
                .sort
            end
          end
        RUBY
      end

      it "returns index of statement end" do
        expect(described_class.new(lines, 2).call).to eq 5
        expect(described_class.new(lines, 7).call).to eq 11
      end
    end

    context "with conditional operators" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              this &&
                that ||
                  cancel
            end
          end
        RUBY
      end

      it "returns index of statement end" do
        expect(described_class.new(lines, 2).call).to eq 4
      end
    end

    context "with an heredoc" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              x = <<~TXT
                hello
                world
              TXT
              x.upcase
            end
          end
        RUBY
      end

      it "returns index of statement end" do
        expect(described_class.new(lines, 2).call).to eq 5
      end
    end

    context "with a single line" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              x + y
            end
          end
        RUBY
      end

      it "returns index of statement end" do
        expect(described_class.new(lines, 2).call).to eq 2
      end
    end

    context "with a line that in not the start of a statement" do
      let(:lines) do
        <<~RUBY.split("\n")
          class User
            def foo
              tasks
                .sum(&:duration)

              Email.new(
                'hello',
                'world'
              )
            end
          end
        RUBY
      end

      it "returns index of statement end" do
        expect(described_class.new(lines, 3).call).to eq 3
        expect(described_class.new(lines, 6).call).to eq 6
      end
    end
  end
end
