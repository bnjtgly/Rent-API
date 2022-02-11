class VerifyOtpValidator
  include Helper::BasicHelper
  include ActiveModel::Model

  attr_accessor(
    :otp
  )

  validate :otp_exist, :required, :otp_expired

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
    @user = User.where(otp: otp).first
  end

  def otp_exist
    errors.add(:otp, 'Please try again. OTP cannot be recognized.') unless @user
  end

  def required
    errors.add(:otp, REQUIRED_MESSAGE) if otp.blank?
  end

  def otp_expired
    errors.add(:otp, 'Please try again. OTP is Expired.') if @user&.otp_sent_at && ((@user.otp_sent_at) <= Time.now.utc)
  end
end
