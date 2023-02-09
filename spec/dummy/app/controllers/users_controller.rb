# frozen_string_literal: true

class UsersController < ApplicationController
  # TODO: add filters
  def index
    authorize!(current_user)
    # TODO: preload user tasks
    # to avoid n+1
    User.all
  end
end
