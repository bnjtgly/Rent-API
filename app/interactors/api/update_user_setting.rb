# frozen_string_literal: true

module Api
  class UpdateUserSetting
    include Interactor

    delegate :data, :current_user, to: :context

    def call
      init
      validate!
      build
    end

    def rollback; end

    private

    def init
      @user_setting = UserSetting.where(id: payload[:user_setting_id]).first

      context.fail!(error: { user_settings_id: ['Not found.'] }) unless @user_setting
      context.fail!(error: { user: ['You do not have access to modify the settings.'] }) unless @user_setting.user_id.eql?(payload[:user_id])
    end

    def build
      @user_setting&.update(
        audit_comment: 'Update User Settings',
        value: payload[:value]
      )
    end

    def validate!
      verify = Api::UpdateUserSettingValidator.new(payload)

      return true if verify.submit

      context.fail!(error: verify.errors)
    end

    def payload
      {
        user_setting_id: data[:user_setting_id],
        user_id: current_user.id,
        value: data[:user_setting][:value]
      }
    end
  end
end