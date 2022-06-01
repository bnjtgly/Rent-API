module PmApi
  class CreateSetupPassword
    include Interactor

    delegate :data, to: :context

    def call
      init
      validate!
      build
    end

    def rollback; end

    private

    def init
      @user = User.where(is_email_verified_token: data[:email_token]).first
      context.fail!(error: { user: ['Please try again. Email token cannot be recognized.'] }) unless @user
    end

    def build
      if @user
        @user&.update(
          audit_comment: 'Setup Password & Verified Email-address.',
          is_email_verified: true,
          is_email_verified_token: nil,
          password: payload[:password],
          password_confirmation: payload[:password_confirmation]
        )
      end

      context.user = @user
      context.user.reload
    end

    def validate!
      verify = PmApi::CreateSetupPasswordValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: @user.id,
        password: data[:user][:password],
        password_confirmation: data[:user][:password_confirmation]
      }
    end

  end
end
