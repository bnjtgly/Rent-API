class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    @chatroom = Chatroom.find(message.chatroom_id)

    payload = {
      conversation: @chatroom,
      users: @chatroom.users,
      messages: @chatroom.messages
    }

    ChatroomsChannel.broadcast_to(@chatroom, payload)
  end
end
