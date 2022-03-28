module Api
  class CreateIsEmailVerifiedValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_id
    )

    validate :user_id_exist, :email_verified

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

    def email_verified
      errors.add(:user_id, 'Your email address is already verified.') if @user.is_email_verified
    end
  end
end
