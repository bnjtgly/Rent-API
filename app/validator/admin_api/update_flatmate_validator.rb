# frozen_string_literal: true

module AdminApi
  class UpdateFlatmateValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :flatmate_id,
      :user_id,
      :group_name
    )

    validate :user_id_exist, :flatmate_id_exist, :required, :group_name_exist

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
      errors.add(:group_name, REQUIRED_MESSAGE) if group_name.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def flatmate_id_exist
      errors.add(:flatmate_id, NOT_FOUND) unless @flatmate
    end

    def group_name_exist
      if @flatmate
        group_exists = Flatmate.where(user_id: @user.id, group_name: group_name).first if @user
        errors.add(:group_name, "#{PLEASE_CHANGE_MESSAGE} #{NAME_EXIST_MESSAGE}") if group_exists && !group_exists.id.eql?(@flatmate.id)
      end
    end
  end
end
