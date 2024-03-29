# frozen_string_literal: true

module Api
  class CreateFlatmateValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :audit_comment,
      :user_id,
      :group_name
    )

    validate :user_id_exist, :required, :group_name_exist

    def submit
      init
      persist!
    end

    private

    def init
      @user = User.where(id: user_id).first
      @flatmate = Flatmate.where(group_name: group_name, user_id: @user.id).first
    end

    def persist!
      return true if valid?

      false
    end

    def required
      errors.add(:user_id, REQUIRED_MESSAGE) if user_id.blank?
      errors.add(:group_name, REQUIRED_MESSAGE) if group_name.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def group_name_exist
      errors.add(:group_name, "#{PLEASE_CHANGE_MESSAGE} #{NAME_EXIST_MESSAGE}") if @flatmate
    end
  end
end
