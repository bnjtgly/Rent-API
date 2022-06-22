# frozen_string_literal: true

module AdminApi
  class TenantApplicationsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/properties
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @tenant_applications = TenantApplication.includes(:user)
      @tenant_applications = @tenant_applications.where(user: { email: params[:email].downcase }) unless params[:email].blank?
      @tenant_applications = @tenant_applications.where(user_id: params[:user_id]) unless params[:user_id].blank?

      pagy, @tenant_applications = pagy(@tenant_applications, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/properties/1
    def show
      @tenant_application = TenantApplication.where(id: params[:tenant_application_id]).first

      if @tenant_application.nil?
        render json: { error: { tenant_application_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # GET /admin_api/tenant_applications/1/history
    def history
      @tenant_application_history = TenantApplicationHistory.where(tenant_application_id: params[:tenant_application_id])
                                                            .order(:created_at)
    end
  end
end
