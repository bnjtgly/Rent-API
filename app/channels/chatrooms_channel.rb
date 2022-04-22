class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    @chatroom = Chatroom.find(params[:room])
    stream_for @chatroom
  end

  def unsubscribed
    # stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
