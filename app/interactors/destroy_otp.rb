class DestroyOtp
  include Interactor

  delegate :data, to: :context

  def call
    build
  end

  private

  def build
    @user = User.where(otp: payload[:otp]).first

    if @user
      @user.update(audit_comment: 'Removed OTP', otp: nil, otp_sent_at: nil)
      return @user
    end

    context.fail!(error: { user: ['We do not recognize your Account. Please try again.'] })
  end

  def payload
    {
      otp: data[:user][:otp]
    }
  end
end