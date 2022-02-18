class SendOtp
  include Interactor
  include EmailConcern
  include SmsConcern

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
          sms_message = "Rento: Your security code is: #{@user.otp}. It expires in 10 minutes. Dont share this code with anyone."
          send_sms(@user.mobile_number, sms_message, 'Rento')
        end

        email_otp({ user_id: @user.id, subject: 'Forgot Password', template_name: 'basic', template_version: 'v1' })
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
