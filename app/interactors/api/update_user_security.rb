module Api
  class UpdateUserSecurity
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private
    def build
      @user_security = UserSecurity.where(id: payload[:user_security_id]).first
      @user_security&.update(
        audit_comment: 'Update User Settings',
        sms_notification: payload[:sms_notification]
      )
    end

    def validate!
      verify = Api::UpdateUserSecurityValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_security_id: data[:user_security_id],
        user_id: current_user.id,
        sms_notification: data[:user_security][:sms_notification]
      }
    end
  end
end
