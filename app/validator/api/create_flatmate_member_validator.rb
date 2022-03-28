# frozen_string_literal: true

module Api
  class CreateFlatmateMemberValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_id,
      :flatmate_id
    )

    validate :user_id_exist, :flatmate_id_exist, :required

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).load_async.first
      @flatmate = Flatmate.where(id: flatmate_id).load_async.first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:flatmate_id, REQUIRED_MESSAGE) if flatmate_id.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def flatmate_id_exist
      errors.add(:flatmate_id, "#{PLEASE_CHANGE_MESSAGE} #{NOT_FOUND}") unless @flatmate
    end
  end
end
