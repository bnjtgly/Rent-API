module PmApi
  class UsersController < ApplicationController
    include Custom::GlobalRefreshToken
    before_action :authenticate_user!, except: %i[setup_password]
    authorize_resource class: PmApi::UsersController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/users
    def index
      @user = User.where(id: current_user.id).first
      @tenant_applications = TenantApplication.includes(:property).where(property: { agency_id: current_user.user_agency.agency.id })

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

    # POST /admin_api/users/:email_token/setup_password
    def setup_password
      interact = PmApi::CreateSetupPassword.call(data: params)

      if interact.success?
        token = Warden::JWTAuth::UserEncoder.new.call(interact.user, :user, nil).first

        render json: { access_token: token, refresh_token: login_refresh_token(token) }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # POST /admin_api/users/setup_account
    def setup_account
      interact = PmApi::CreateSetupAccount.call(data: params, current_user: current_user)

      if interact.success?
        @user = interact.user
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

    # GET /pm_api/users/notifications
    def dashboard
      @properties = Property.where(agency_id: current_user.user_agency.agency.id).load_async
      @properties = @properties.sort_by { |property| property[:details][:views] }
      @property_views = Property.select("sum((details->>'views')::integer) AS total_views")
                                .where(agency_id: current_user.user_agency.agency.id).load_async.first

      @applicants = TenantApplication.includes(:property).where(property: { agency_id: current_user.user_agency.agency.id }).load_async

      @tenant_applications = TenantApplication.all.load_async
      @tenant_applications = PmApi::TenantApplications::TenantRankingService.new(@tenant_applications).call
    end
  end
end
