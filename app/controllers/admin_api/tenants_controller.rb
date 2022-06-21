module AdminApi
  class TenantsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: AdminApi::TenantsController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/tenants
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20
      tenants = Role.where(role_name: 'USER').load_async.first

      @tenants = User.select('users.*, NULL as profile_progress')
                     .includes(user_role: :role)
                     .where(user_role: { role_id: tenants.id })
                     .load_async

      pagy, @tenants = pagy(@tenants, items: items_per_page)

      @tenants = AdminApi::Profile::ProfileService.new(@tenants).call
      @pagination = pagy_metadata(pagy)
    end

    # GET /admin_api/tenants/top_applicants
    def top_applicants
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

      @tenant_applications = TenantApplication.all
      @tenant_applications = @tenant_applications.where(property_id: params[:property_id]) unless params[:property_id].blank?

      pagy, @tenant_applications = pagy(@tenant_applications, items: items_per_page)
      @tenant_applications = AdminApi::TenantApplications::TenantRankingService.new(@tenant_applications).call
      @pagination = pagy_metadata(pagy)
    end
  end
end