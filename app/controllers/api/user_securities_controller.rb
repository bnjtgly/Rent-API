module Api
  class UserSecuritiesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::UserSecuritiesController

    def index
      @user_securities = UserSecurity.where(user_id: current_user.id)

      unless @user_securities
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end

    def update
      interact = Api::UpdateUserSecurity.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
