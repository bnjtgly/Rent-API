class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :complete_name, :avatar

  attribute :role do |user|
    user.user_role.role.role_name
  end

  attribute :chatrooms do |user|
    user.chatrooms.uniq
  end
end