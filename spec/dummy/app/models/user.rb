# frozen_string_literal: true

# TODO: use an STI
class User < ApplicationRecord
  # TODO: extract in a service
  def compute
    x + y
  end

  def send_email
    x + y
    # TODO: improve performance
    User.all
  end
end
