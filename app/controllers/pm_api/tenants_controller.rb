module PmApi
  class TenantsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::TenantsController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/tenants
    def index
      items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20
      @tenants = User.includes(user_role: :role, tenant_applications: :property)

      # Filter tenants by property's agency.
      @tenants = @tenants.where(property: { agency_id: current_user.user_agency.agency_id })

      @tenants = @tenants.where('LOWER(email) LIKE ?', "%#{params[:email].downcase}%") unless params[:email].blank?

      pagy, @tenants = pagy(@tenants, items: items_per_page)
      @pagination = pagy_metadata(pagy)
    end

    # GET /pm_api/tenants/top_applicants
    def top_applicants
      @tenant_applications = TenantApplication.all

      @tenant_applications = @tenant_applications.where(property_id: params[:property_id]) unless params[:property_id].blank?

      @tenant_applications = PmApi::TenantApplications::TenantRankingService.new(@tenant_applications).call
    end
  end
end
