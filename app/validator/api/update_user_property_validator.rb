# frozen_string_literal: true

module Api
  class UpdateUserPropertyValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_id,
      :user_property_id,
      :is_deleted
    )

    validate :user_id_exist, :user_property_id_exist, :required, :valid_is_deleted, :valid_access

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).first
      @user_properties = UserProperty.where(id: user_property_id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:is_deleted, REQUIRED_MESSAGE) if is_deleted.nil?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def user_property_id_exist
      errors.add(:user_property_id, NOT_FOUND) unless @user_properties
    end

    def valid_is_deleted
      errors.add(:is_deleted, VALID_BOOLEAN_MESSAGE) unless is_true_false(is_deleted.to_s)
    end

    def valid_access
      if @user && @user_properties
        errors.add(:user_id, INVALID_ACCESS) unless @user_properties.user_id.eql?(@user.id)
      end
    end
  end
end
