# frozen_string_literal: true

module Api
  class UpdatePassword
    include Interactor

    delegate :data, :ocr, :current_user, to: :context

    def call
      validate!
      build
    end

    def rollback; end

    private

    def build
      @user = User.where(id: payload[:user_id]).first

      @user&.update(
        audit_comment: 'Update User',
        password: payload[:password]
      )

      context.user = @user
    end

    def validate!
      verify = Api::UpdatePasswordValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: current_user.id,
        current_password: data[:password][:current_password],
        password: data[:password][:password],
        password_confirmation: data[:password][:password_confirmation],
      }
    end
  end
end
