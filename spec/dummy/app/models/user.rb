# frozen_string_literal: true

# TODO: use an STI
class User < ApplicationRecord
  # TODO: extract in a service
  # since it is a lot of logic
  def compute
    x + y # rubocop:disable Layout/ExtraSpacing
  end

  def send_email
    x + y
    # TODO: improve performance
    if true
      do_this
      do_that # rubocop:disable Naming/ConstantName
    else
      do_something_else
    end
  end
end
