# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!

  # POST /messages
  def create
    interact = CreateMessage.call(data: params, current_user: current_user)

    if interact.success?
      @message = interact.message
    else
      render json: { error: interact.error }, status: 422
    end
  end
end
