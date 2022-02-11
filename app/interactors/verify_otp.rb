class VerifyOtp
  include Interactor

  delegate :data, to: :context

  def call
    validate!
    build
  end

  private

  def build; end

  def validate!
    verify = VerifyOtpValidator.new(payload)

    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      otp: data[:user][:otp]
    }
  end
end
