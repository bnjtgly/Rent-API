module Api
  class UpdateOtpVerification
    include Interactor
    include SmsConcern

    delegate :current_user, to: :context

    def call
      build
    end

    def rollback; end

    private

    def build
      @user = User.where(id: current_user.id).first

      if @user
        if @user.is_mobile_verified
          context.fail!(error: { user: ['Mobile is already verified.'] })
        else
          @user.generate_otp!
          @user.otp_verification.update(otp: @user.otp, audit_comment: 'Resend OTP')
          sms_message = "Rento: Your security code is: #{@user.otp}. It expires in 10 minutes. Dont share this code with anyone."
          send_sms(@user.mobile_number, sms_message, 'Rento')
        end
      else
        context.fail!(error: { user: ['We do not recognize your Account. Please try again.'] })
      end
    end

    def payload
      {
        user_id: current_user.id
      }
    end

  end
end
