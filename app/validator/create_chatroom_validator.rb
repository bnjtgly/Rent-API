# frozen_string_literal: true

class CreateChatroomValidator
  include Helper::BasicHelper
  include ActiveModel::API

  attr_accessor(
    :user_id,
    :sender_id,
    :users
  )

  validate :user_id_exist, :required, :valid_users

  def submit
    init
    persist!
  end

  private

  def init
    @user = User.where(id: user_id).load_async.first
  end

  def persist!
    return true if valid?

    false
  end

  def required
    errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
    errors.add(:users, REQUIRED_MESSAGE) if users.blank?
  end

  def user_id_exist
    errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
  end

  def valid_users
    unless users
      users.each do |email|
        errors.add(:users, 'Recipient does not exists.') unless User.find_by(email: email)
      end
    end
  end
end

