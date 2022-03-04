# frozen_string_literal: true

module Api
  class UpdateUserPersonalInfo
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
        first_name: payload[:first_name],
        last_name: payload[:last_name],
        gender_id: payload[:gender_id],
        phone: payload[:phone],
        date_of_birth: payload[:date_of_birth]
      )

      context.user = @user
    end

    def validate!
      verify = Api::UpdateUserPersonalInfoValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_id: current_user.id,
        first_name: data[:user][:first_name],
        last_name: data[:user][:last_name],
        gender_id: data[:user][:gender_id],
        phone: data[:user][:phone],
        date_of_birth: data[:user][:date_of_birth]
      }
    end

  end
end
