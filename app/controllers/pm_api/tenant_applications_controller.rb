module PmApi
    class TenantApplicationsController < ApplicationController
        before_action :authenticate_user!
        authorize_resource class: PmApi::TenantApplicationsController

        # GET /pm_api/tenant_applications
        def index
            pagy, @tenant_applications = pagy(TenantApplication.includes(flatmate: :flatmate_members))

            @tenant_applications = @tenant_applications.select('tenant_applications.*, NULL as income')

            @tenant_applications = PmApi::IncomeService.new(@tenant_applications).call

            pagy_headers_merge(pagy)
        end

        # GET /pm_api/tenant_applications/1
        def show
            @tenant_application = TenantApplication.where(id: params[:tenant_application_id])

            @tenant_application = @tenant_application.select('tenant_applications.*, NULL as income')

            @tenant_application = PmApi::IncomeService.new(@tenant_application).call

            @tenant_application = @tenant_application.first
    
            if @tenant_application.nil?
            render json: { error: { tenant_application_id: ['Not Found.'] } }, status: :not_found
            end
        end
    end
end
