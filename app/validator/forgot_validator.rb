class ForgotValidator
  include Helper::BasicHelper
  include ActiveModel::Model

  attr_accessor(
    :email
  )

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :user_email_exist, :required

  def submit
    init
    persist!
  end

  private

  def persist!
    return true if valid?

    false
  end

  def init
    @user = User.where(email: email).first
  end

  def user_email_exist
    errors.add(:user_id, USER_ID_NOT_FOUND) unless @user
  end

  def required
    errors.add(:email, REQUIRED_MESSAGE) if email.blank?
  end
end
