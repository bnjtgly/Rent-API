# frozen_string_literal: true

module Api
  class UserSettingsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::UserSettingsController

    # GET /api/user_settings
    def index
      @user_settings = UserSetting.where(user_id: current_user.id)

      unless @user_settings
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # PATCH/PUT /api/user_settings/1
    def update
      interact = Api::UpdateUserSetting.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
