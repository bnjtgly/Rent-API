# frozen_string_literal: true

class ChatroomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.where(id: current_user.id).first
    @chatrooms = @user.chatrooms.uniq
    get_participants if @chatrooms
  end

  def show
    @user = User.where(id: current_user.id).first
    chatroom = @user.chatrooms.find(params[:id])

    render json: ChatroomSerializer.new(chatroom)
  end

  # POST /chatrooms
  def create
    interact = CreateChatroom.call(data: params, current_user: current_user)

    if interact.success?
      @chatroom = interact.chatroom
    else
      render json: { error: interact.error }, status: 422
    end
  end

  private
  def get_participants
    @chatrooms.map do |conversation|
      participants = []
      users = User.where(id: conversation.participants)
      conversation.title = sanitize_title conversation.title

      users.map do |user|
        participants << {
          user_id: user.id,
          complete_name: user.complete_name,
          avatar: user.avatar.url,
        }
      end

      conversation.participants = participants
    end
  end

  def sanitize_title(title)
    title.gsub(current_user.complete_name, '').try(:strip)
  end
end