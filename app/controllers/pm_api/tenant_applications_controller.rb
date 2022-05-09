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
    end
end
