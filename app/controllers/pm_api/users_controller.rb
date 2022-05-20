module PmApi
  class UsersController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::UsersController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/users
    def index
      @user = User.where(id: current_user.id).first

      unless @user
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # PATCH/PUT /pm_api/update_account/1
    def update_account
      interact = PmApi::UpdateAccount.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # POST /pm_api/users/setup_avatar
    def setup_avatar
      interact = PmApi::CreateOrUpdateAvatar.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # GET /pm_api/users/notifications
    def notifications
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @notifications = current_user.notifications.newest_first

      pagy, @notifications = pagy(@notifications, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end
  end
end
