# frozen_string_literal: true

module PmApi
  class UpdateUserSecurityValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_security_id,
      :user_id,
      :sms_notification
    )

    validate :user_id_exist, :user_security_id_exist, :required, :valid_sms_notification, :valid_access

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).load_async.first
      @user_security = UserSecurity.where(id: user_security_id).load_async.first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:user_security_id, REQUIRED_MESSAGE) if user_security_id.blank?
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:sms_notification, REQUIRED_MESSAGE) if sms_notification.nil?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def user_security_id_exist
      errors.add(:user_security_id, NOT_FOUND) unless @user_security
    end

    def valid_sms_notification
      errors.add(:sms_notification, VALID_BOOLEAN_MESSAGE) unless is_true_false(sms_notification.to_s)
    end

    def valid_access
      if @user && @user_security
        errors.add(:user_id, INVALID_ACCESS) unless @user_security.user_id.eql?(@user.id)
      end
    end
  end
end
