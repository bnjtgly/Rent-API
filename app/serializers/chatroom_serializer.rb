class ChatroomSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :participants, :users, :messages, :sender_id

  attribute :role do |room|
    User.find(room.participants.first).user_role.role.role_name
  end
  attribute :users do |room|
    UserSerializer.new(room.users.uniq)
  end
end