# frozen_string_literal: true

module Api
  class ProfileController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::ProfileController

    # PATCH/PUT /api/profile/update_personal_info
    def update_personal_info
      interact = Api::UpdateUserPersonalInfo.call(data: params, current_user: current_user)

      if interact.success?
        @user = interact.user
        render 'api/users/index'
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
