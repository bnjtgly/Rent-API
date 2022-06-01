module Api
  class UpdateAccountSetup
    include Interactor

    delegate :data, :ocr, :current_user, to: :context

    def call
      build
    end

    def rollback; end

    private
    def build
      ap payload[:cover_letter]
      @user = User.where(id: payload[:user_id]).first

      @user&.update(
        audit_comment: 'Update Cover Letter',
        account_setup: {
          cover_letter: payload[:cover_letter]
        }
      )

      context.user = @user.account_setup
    end

    def payload
      {
        user_id: current_user.id,
        cover_letter: data[:account_setup][:cover_letter]
      }
    end
  end
end
