class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :email, :complete_name

  attribute :chatrooms do |user|
    user.chatrooms.uniq
  end
end