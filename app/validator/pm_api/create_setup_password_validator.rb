module PmApi
  class CreateSetupPasswordValidator
    include Helper::BasicHelper
    include ActiveModel::Model

    attr_accessor(
      :user_id,
      :password,
      :password_confirmation
    )

    validates_confirmation_of :password
    validate :user_id_exist, :required, :password_requirements

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

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def required
      errors.add(:password, REQUIRED_MESSAGE) if password.blank?
      errors.add(:password_confirmation, REQUIRED_MESSAGE) if password_confirmation.blank?
    end

    def password_requirements
      return if password.blank? || password =~ /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x

      errors.add(:password, PASSWORD_REQUIREMENTS_MESSAGE)
    end

  end
end
