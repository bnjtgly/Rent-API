module Api
  class UpdateIsMobileVerified
    include Interactor

    delegate :data, to: :context

    def call
      build
    end

    private

    def build
      @user = User.includes(:otp_verification).where(otp: payload[:otp]).first

      if @user&.otp_verification
        if @user.otp_verification.otp.eql?(payload[:otp])
          @user.update(
            audit_comment: 'Mobile Verification',
            mobile_country_code_id: @user.otp_verification.mobile_country_code_id,
            mobile: @user.otp_verification.mobile,
            is_mobile_verified: true
          )
          # SMS notification here.
        else
          context.fail!(error: { otp: ['Please try again. OTP cannot be recognized.'] })
        end
      end
    end

    def payload
      {
        otp: data[:user][:otp]
      }
    end
  end
end
