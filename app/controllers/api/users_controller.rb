module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::UsersController

    # GET /api/users
    def index
      @user = User.where(id: current_user.id).first
      if @user
        render 'api/users/index'
      else
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # POST /api/users/mobile_verification
    def mobile_verification
      interact = Api::Organizers::MobileVerification.call(data: params)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
