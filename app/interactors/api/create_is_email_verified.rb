module Api
  class CreateIsEmailVerified
    include Interactor
    include EmailConcern

    delegate :current_user, to: :context

    def call
      validate!
      build
    end

    private

    def build
      @user = User.where(id: current_user.id).first
      if @user && (!@user.is_email_verified && !@user.is_email_verified_token.blank?)
        email_verification({ user_id: @user.id, subject: 'Verify Email Address', template_name: 'rento', template_version: 'v1' })
      end
    end

    def validate!
      verify = Api::CreateIsEmailVerifiedValidator.new(payload)
      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: current_user.id
      }
    end
  end
end
