class UsersController < ApplicationController
    before_action :authenticate_user!

    # GET /users/current
    def current
        @user = User.where(id: current_user.id).first
  
        unless @user
          render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
        end
    end
end