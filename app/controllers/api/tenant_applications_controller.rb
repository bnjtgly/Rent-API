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

      pagy_headers_merge(pagy)
    end
  end
end