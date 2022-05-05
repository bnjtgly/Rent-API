module PmApi
  class UsersController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::UsersController

    # GET /pm_api/users
    def index
      @user = User.where(id: current_user.id).first

      unless @user
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end
