# frozen_string_literal: true

module Api
  class UpdateIsEmailVerified
    include Interactor

    delegate :data, to: :context

    def call
      build
    end

    def rollback; end

    private
    def build
      @user = User.where(is_email_verified_token: payload[:email_token]).first

      if @user
        @user.update(is_email_verified: true, is_email_verified_token: nil, audit_comment: 'Confirm Email')
        return @user
      end

      context.fail!(error: { user: ['We do not recognize your Account. Please try again.'] })
    end

    def payload
      {
        email_token: data[:email_token]
      }
    end
  end
end
