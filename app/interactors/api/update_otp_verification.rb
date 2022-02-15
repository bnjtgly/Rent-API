module Api
  class UpdateOtpVerification
    include Interactor

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
          # SMS notification here
          ap "Please check your mobile phone for OTP"
          ap @user.otp
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
