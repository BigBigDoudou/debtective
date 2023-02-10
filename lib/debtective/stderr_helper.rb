# frozen_string_literal: true

module Debtective
  # Silence the $stderr
  module StderrHelper
    # @return void
    def suppress_stderr
      original_stderr = $stderr.clone
      $stderr.reopen(File.new("/dev/null", "w"))
      yield
    ensure
      $stderr.reopen(original_stderr)
    end
  end
end
