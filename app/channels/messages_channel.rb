class MessagesChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find(params[:chatroom])
    stream_for chatroom
  end

  def unsubscribed
    # stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
