# frozen_string_literal: true

class CreateMessageValidator
  include Helper::BasicHelper
  include ActiveModel::API

  attr_accessor(
    :user_id,
    :chatroom_id,
    :body
  )

  validate :user_id_exist, :required, :chatroom_id_exist

  def submit
    init
    persist!
  end

  private

  def init
    @user = User.where(id: user_id).load_async.first
    @chatroom = Chatroom.where(id: chatroom_id).load_async.first
  end

  def persist!
    return true if valid?

    false
  end

  def required
    errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
    errors.add(:chatroom_id, REQUIRED_MESSAGE) if chatroom_id.blank?
    errors.add(:body, REQUIRED_MESSAGE) if body.blank?
  end

  def user_id_exist
    errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
  end

  def chatroom_id_exist
    errors.add(:chatroom_id, NOT_FOUND) unless @chatroom
  end
end

