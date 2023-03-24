# frozen_string_literal: true

require "debtective"
require_relative "comments/command"

module Debtective
  # Handle commands from CLI
  class Command
    # @param args [Array<String>] ARGVs from command line (order matters)
    def initialize(args)
      @args = args
    end

    # Forward to the proper command
    def call
      case @args.first&.delete("--")
      when "comments"
        Debtective::Comments::Command.new(@args, quiet: quiet?).call
      when "gems"
        puts "Upcoming feature!"
      else
        puts "Please pass one of this options: [--comments, --gems]"
      end
    end

    private

    def quiet?
      @args.include?("--quiet")
    end
  end
end
