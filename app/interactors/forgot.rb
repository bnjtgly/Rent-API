class Forgot
  include Interactor

  delegate :data, to: :context

  def call
    validate!
    build
  end

  private

  def build
    @user = User.where(email: payload[:email]).first
    @user.update(audit_comment: 'Forgot Password')

    context.user = @user
  end

  def validate!
    verify = ForgotValidator.new(payload)

    return true if verify.submit

    context.fail!(error: verify.errors)
  end

  def payload
    {
      email: data[:user][:email]
    }
  end
end
