module Api
  class UsersController < ApplicationController

    before_action :authenticate_user!, except: [:confirm_email]
    authorize_resource class: Api::UsersController

    # GET /api/users
    def index
      @user = User.where(id: current_user.id).first

      @total_income = Api::IncomeService.new(@user.incomes).call if @user.incomes
      @profile_completion_percentage = Api::ProfileService.new(current_user).call
      @user_overall_score = Api::ProfileScoreService.new(current_user).call['overall_score']

      unless @user
        render json: { error: { user_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # PATCH/PUT /api/users/update_account
    def update_account
      interact = Api::UpdateAccount.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    def update_personal_info
      interact = Api::UpdateUserPersonalInfo.call(data: params, current_user: current_user)

      if interact.success?
        @user = interact.user
        @profile_completion_percentage = Api::ProfileService.new(current_user).call
      else
        render json: { error: interact.error }, status: 422
      end
    end

    def update_account_setup
      interact = Api::UpdateAccountSetup.call(data: params, current_user: current_user)

      if interact.success?
        render json: { data: { account_setup: interact.user } }
      else
        render json: { error: interact.error }, status: 422
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

    # POST /api/users/resend_otp
    def resend_otp
      interact = Api::UpdateOtpVerification.call(current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # GET /api/users/:email_token/confirm_email/
    def confirm_email
      interact = Api::UpdateIsEmailVerified.call(data: params)
      if interact.success?
        render json: { message: 'Successfully Verified Email' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # POST /api/users/resend_email_verification
    def resend_email_verification
      interact = Api::CreateIsEmailVerified.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # POST /api/users/setup_avatar
    def setup_avatar
      interact = Api::CreateOrUpdateAvatar.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # GET /api/users/notifications
    def notifications
      pagy, @notifications = pagy(current_user.notifications.newest_first)

      @notifications = @notifications.where(id: params[:notification_id]) unless params[:notification_id].blank?

      pagy_headers_merge(pagy)
    end
  end
end



