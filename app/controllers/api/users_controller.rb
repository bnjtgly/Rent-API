module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:confirm_email]
    authorize_resource class: Api::UsersController

    # GET /api/users
    def index
      @user = User.where(id: current_user.id).first
      unless @user
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
      ap "Test"
      interact = Api::CreateOrUpdateAvatar.call(data: params, current_user: current_user)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

  end
end
