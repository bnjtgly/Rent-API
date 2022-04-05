# frozen_string_literal: true

module Api
  class UpdateAccountValidator
    include Helper::BasicHelper
    include ActiveModel::API

    attr_accessor(
      :user_id,
      :email,
      :first_name,
      :last_name
    )

    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validate :user_id_exist, :email_exist,:required, :valid_name

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
      errors.add(:email, REQUIRED_MESSAGE) if email.blank?
      errors.add(:first_name, REQUIRED_MESSAGE) if first_name.blank?
      errors.add(:last_name, REQUIRED_MESSAGE) if last_name.blank?
    end

    def user_id_exist
      errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
    end

    def email_exist
      unless @user.email.eql?(email)
        errors.add(:email, 'Email address already exist. Please try again using different email address.') if User.exists?(email: email.try(:downcase).try(:strip))
      end
    end

    def valid_name
      if valid_english_alphabets?(first_name).eql?(false)
        errors.add(:first_name,
                   "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}")
      end
      if valid_english_alphabets?(last_name).eql?(false)
        errors.add(:last_name,
                   "#{PLEASE_CHANGE_MESSAGE} #{ENGLISH_ALPHABETS_ONLY_MESSAGE}")
      end
    end

  end
end
