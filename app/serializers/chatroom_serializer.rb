class ChatroomSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :participants, :users, :messages, :sender_id

  attribute :title do |room|
    user = User.find(room.participants.first)
    room.title.gsub(user.complete_name, '')
  end
  attribute :role do |room|
    User.find(room.participants.first).user_role.role.role_name
  end
  attribute :users do |room|
    UserSerializer.new(room.users.uniq)
  end
end