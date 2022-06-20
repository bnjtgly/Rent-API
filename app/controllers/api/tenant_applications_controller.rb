# frozen_string_literal: true

module Api
  class TenantApplicationsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: Api::TenantApplicationsController
    after_action { pagy_headers_merge(@pagy) if @pagy }

    # GET /api/tenant_applications
    def index
      pagy, @tenant_applications = pagy(TenantApplication.includes(:property, :user))

      @tenant_applications = @tenant_applications.where(user_id: current_user.id)

      @user_overall_score = Api::Profile::ProfileScoreService.new(current_user).call['overall_score']

      pagy_headers_merge(pagy)
    end

    # GET /api/tenant_applications/1
    def show
      @tenant_application = TenantApplication.where(id: params[:tenant_application_id], user_id: current_user.id).first
      @user_overall_score = Api::Profile::ProfileScoreService.new(current_user).call['overall_score']

      if @tenant_application.nil?
        render json: { error: { tenant_application_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # POST /api/tenant_applications
    def create
      interact = Api::CreateTenantApplication.call(data: params, current_user: current_user)

      if interact.success?
        @tenant_application = interact.tenant_application
      else
        render json: { error: interact.error }, status: 422
      end
    end

  end
end