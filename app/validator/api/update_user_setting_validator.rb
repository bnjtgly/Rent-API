# frozen_string_literal: true

module Api
  class UpdateUserSettingValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_setting_id,
      :user_id,
      :value
    )

    validate :user_id_exist, :user_setting_id_exist, :required, :valid_value

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).load_async.first
      @user_setting = UserSetting.where(id: user_setting_id).load_async.first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:user_setting_id, REQUIRED_MESSAGE) if user_setting_id.blank?
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:value, REQUIRED_MESSAGE) if value.nil?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def user_setting_id_exist
      errors.add(:user_setting_id, NOT_FOUND) unless @user_setting
    end

    def valid_value
      errors.add(:value, VALID_BOOLEAN_MESSAGE) unless is_true_false(value.to_s)
    end
  end
end
