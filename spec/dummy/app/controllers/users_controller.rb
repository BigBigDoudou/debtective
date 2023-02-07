# frozen_string_literal: true

class UsersController < ApplicationController
  # TODO: add filters
  def index
    authorize!(current_user)
    # TODO: preload user tasks
    User.all
  end
end
