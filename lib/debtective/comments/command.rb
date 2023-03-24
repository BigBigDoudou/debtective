# frozen_string_literal: true

require_relative "export"

module Debtective
  module Comments
    # Handle comments command and given ARGVs
    class Command
      TYPE_OPTIONS = %w[fixme magic note offense shebang todo yard].freeze

      # @param args [Array<String>] ARGVs from command line (order matters)
      # @param quiet [Boolean]
      def initialize(args, quiet: false)
        @args = args
        @quiet = quiet
      end

      # @return [Debtective::Comments::Export]
      def call
        Export.new(
          user_name: user_name,
          quiet: @quiet,
          included_types: included_types,
          excluded_types: excluded_types,
          included_paths: paths("include"),
          excluded_paths: paths("exclude")
        ).call
      end

      private

      def user_name
        if @args.include?("--me")
          `git config user.name`.strip
        elsif @args.include?("--user")
          @args[@args.index("--user") + 1]
        end
      end

      def included_types
        TYPE_OPTIONS.select { @args.include?("--#{_1}") }
      end

      def excluded_types
        TYPE_OPTIONS.select { @args.include?("--no-#{_1}") }
      end

      def paths(rule)
        return [] unless @args.include?("--#{rule}")

        paths = []
        @args[(@args.index("--#{rule}") + 1)..].each do |arg|
          return paths if arg.match?(/^--.*/)

          paths << arg
        end
        paths
      end
    end
  end
end
