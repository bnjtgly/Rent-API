# frozen_string_literal: true

class ResetValidator
  include Helper::BasicHelper
  include ActiveModel::Model

  attr_accessor(
    :otp,
    :password,
    :password_confirmation
  )

  validates_confirmation_of :password
  validate :required, :password_requirements

  def submit
    persist!
  end

  private

  def persist!
    return true if valid?

    false
  end

  def password_requirements
    return if password.blank? || password =~ /\A(?=.{6,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x

    errors.add(:password, PASSWORD_REQUIREMENTS_MESSAGE)
  end

  def required
    errors.add(:password, REQUIRED_MESSAGE) if password.blank?
    errors.add(:password_confirmation, REQUIRED_MESSAGE) if password_confirmation.blank?
  end
end
