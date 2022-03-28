module Api
  class CreateOrUpdateAvatarValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_id,
      :avatar
    )

    validate :user_id_exist, :required, :valid_avatar

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
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:avatar, REQUIRED_MESSAGE) if avatar.blank?
    end

    def valid_avatar
      errors.add(:avatar, VALID_IMG_TYPE_MESSAGE) unless valid_img_type?(avatar)
      errors.add(:avatar, VALID_IMG_SIZE_MESSAGE) if avatar.size > 5.megabytes
      errors.add(:avatar, VALID_BASE64_MESSAGE) unless valid_base64?(avatar)
    end
  end
end
