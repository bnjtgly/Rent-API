# frozen_string_literal: true

module Api
  class UpdatePasswordValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_id,
      :current_password,
      :password,
      :password_confirmation
    )

    validates_confirmation_of :password
    validate :user_id_exist, :required, :password_requirements, :valid_new_password, :valid_current_password

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:current_password, REQUIRED_MESSAGE) if current_password.blank?
      errors.add(:password, REQUIRED_MESSAGE) if password.blank?
      errors.add(:password_confirmation, REQUIRED_MESSAGE) if password_confirmation.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def valid_current_password
      errors.add(:current_password, INCORRECT_PASSWORD) unless @user.valid_password?(current_password)
    end

    def valid_new_password
      if password.eql?(password_confirmation) && current_password.eql?(password)
        errors.add(:password,
                   'New password should not be the same as the current one.')
      end
    end

    def password_requirements
      return if password.blank? || password =~ /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x

      errors.add(:password,
                 'Password should have more than 6 characters including 1 lower letter, 1 uppercase letter, 1 number and 1 symbol')
    end

  end
end
