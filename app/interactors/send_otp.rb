class SendOtp
  include Interactor
  # include EmailConcern
  # include SmsConcern

  delegate :data, to: :context

  def call
    build
  end

  def rollback; end

  private

  def build
    if payload[:email]
      @user = User.where(email: payload[:email]).first

      if @user
        @user.generate_otp!

        if @user.mobile && @user.mobile_country_code_id
          # SMS send OTP
          ap "SEND OTP to mobile"
        end
        # Send OTP to email
        ap @user.otp
      else
        context.fail!(error: { user: ['We do not recognize your Account. Please try again.'] })
      end

    else
      context.fail!(error: { email: ['This field is required.'] })
    end
  end

  def payload
    {
      email: data[:user][:email]
    }
  end
end
