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
            @tenant_application = TenantApplication.select('tenant_applications.*, NULL as income')
                                                   .where(id: params[:tenant_application_id])

            @tenant_application = PmApi::IncomeService.new(@tenant_application).call.first

            if @tenant_application.nil?
                render json: { error: { tenant_application_id: ['Not Found.'] } }, status: :not_found
            end
        end

        # PATCH/PUT /pm_api/tenant_applications/1
        def update
            interact = PmApi::UpdateTenantApplication.call(data: params, current_user: current_user)

            if interact.success?
                render json: { message: 'Success' }
            else
                render json: { error: interact.error }, status: 422
            end
        end
    end
end
