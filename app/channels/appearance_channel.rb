class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "appearance_channel"
    @user = Chatroom.find(params[:room])
    stream_for @user
  end

  def appear
    verified_user = User.where(id: current_user.id).first
    verified_user&.update!(is_online: true)

    data = {
      id: verified_user.id,
      email: verified_user.email,
      complete_name: verified_user.complete_name,
      is_online: verified_user.is_online
    }

    AppearanceBroadcastJob.perform_later(@user, data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    verified_user = User.where(id: current_user.id).first
    verified_user&.update!(is_online: false)

    data = {
      id: verified_user.id,
      email: verified_user.email,
      complete_name: verified_user.complete_name,
      is_online: verified_user.is_online
    }

    AppearanceBroadcastJob.perform_later(@user, data)
    ActionCable.server.remote_connections.where(current_user: User.find(current_user.id)).disconnect
  end
end
