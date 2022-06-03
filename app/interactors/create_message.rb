# frozen_string_literal: true

class CreateMessage
  include Interactor

  delegate :data, :current_user, to: :context

  def call
    validate!
    build
  end

  def rollback
    context.message&.destroy
  end

  private

  def build
    @message = Message.new(payload)
    @message.body = @message.body.encode('utf-8', 'binary', :undef => :replace)

    Message.transaction do
      @message.save
    end

    context.message = @message
  end

  def validate!
    verify = CreateMessageValidator.new(payload)
    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      user_id: current_user.id,
      chatroom_id: data[:message][:chatroom_id],
      body: data[:message][:body]
    }
  end
end
