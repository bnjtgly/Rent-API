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
  end
end
