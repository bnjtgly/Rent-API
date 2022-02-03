module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!

    # GET /api/users
    def index
      @user = User.where(id: current_user.id).first
      if @user
        render 'api/users/index'
      else
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end
