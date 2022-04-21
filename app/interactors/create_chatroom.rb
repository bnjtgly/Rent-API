class CreateChatroom
  include Interactor

  delegate :data, :current_user, to: :context

  def call
    validate!
    build
  end

  def rollback
    context.chatroom&.destroy
  end

  private

  def build
    @user = User.where(id: payload[:user_id]).first
    @chatroom = @user.chatrooms.new(payload.except(:users, :user_id))

    if @chatroom.save
      participants = add_users_to_chatroom
      @chatroom&.update(participants: participants)
      @chatroom&.update(title: set_participants_name(@chatroom.participants).titleize)
    end

    context.chatroom = @chatroom
  end

  def validate!
    verify = CreateChatroomValidator.new(payload)
    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      user_id: current_user.id,
      sender_id: current_user.id,
      users: data[:users]
    }
  end

  def set_participants_name(participants)
    User.find(participants).pluck(:first_name, :last_name).join(' ')
  end

  def add_users_to_chatroom
    participants = []
    payload[:users].each do |name|
      user = User.find_by(email: name)

      unless @chatroom.users.include?(user)
        @chatroom.users << user
        participants << user.id
      end
    end

    participants
  end
end
