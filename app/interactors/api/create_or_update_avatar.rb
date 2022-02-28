module Api
  class CreateOrUpdateAvatar
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @user = User.where(id: current_user.id).first
      ac = if @user.avatar.present?
             'Update Avatar'
           else
             'Create Avatar'
           end
      @user&.update(audit_comment: ac, avatar: payload[:avatar])
    end

    def validate!
      verify = Api::CreateOrUpdateAvatarValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: current_user.id,
        avatar: data[:user][:avatar]
      }
    end
  end
end
