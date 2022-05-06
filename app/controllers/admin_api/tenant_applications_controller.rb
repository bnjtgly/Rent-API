# frozen_string_literal: true

module AdminApi
  class TenantApplicationsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/properties
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      if current_user.user_role.role.role_name.eql?('PROPERTY MANAGER')
        @tenant_applications = TenantApplication.includes(property: :user_agency).where(user_agency: { host_id: current_user.id })
      else
        @tenant_applications = TenantApplication.all
      end

      pagy, @tenant_applications = pagy(@tenant_applications, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end
  end
end