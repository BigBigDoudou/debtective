# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  # rubocop:disable Metrics/MethodLength
  self.abstract_class = true
  # rubocop:enable Metrics/MethodLength
end
