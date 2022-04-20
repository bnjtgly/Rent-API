class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    @chatroom = Chatroom.find(params[:room])
    stream_for @chatroom
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
