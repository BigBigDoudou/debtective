# frozen_string_literal: true

# TODO: use an STI
class User < ApplicationRecord
  # TODO: extract in a service
  # since it is a lot of logic
  def compute
    x + y
  end

  def send_email
    x + y
    # TODO: improve performance
    if true
      do_this
      do_that
    else
      do_something_else
    end
  end
end
