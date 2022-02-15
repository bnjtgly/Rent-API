class Reset
  include Interactor
  # include EmailConcern

  delegate :data, to: :context

  def call
    validate!
    build
  end

  private

  def build
    @user = User.where(otp: payload[:otp]).first

    @user&.update(
      audit_comment: 'Reset Password',
      password: payload[:password]
    )

    # Email confirmation here.
    ap "Password successfully reset."
  end

  def validate!
    verify = ResetValidator.new(payload)

    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      otp: data[:user][:otp],
      password: data[:user][:password],
      password_confirmation: data[:user][:password_confirmation]
    }
  end
end
