module PmApi
    class TenantApplicationsController < ApplicationController
        before_action :authenticate_user!
        authorize_resource class: PmApi::TenantApplicationsController

        after_action { pagy_metadata(@pagy) if @pagy }

        # GET /pm_api/tenant_applications
        def index
            items_per_page = !params[:max_items].blank? ? params[:max_items].to_i : 20

            @tenant_applications = TenantApplication.select('tenant_applications.*, NULL as income, NULL as overall_score')
                                                    .includes(:property, flatmate: :flatmate_members)
                                                    .where(property: { agency_id: current_user.user_agency.agency.id })



            @tenant_applications = @tenant_applications.where(id: params[:compare_id]) unless params[:compare_id].blank?

            pagy, @tenant_applications = pagy(@tenant_applications, items: items_per_page)

            @tenant_applications = PmApi::IncomeService.new(@tenant_applications).call
            @tenant_applications = PmApi::ProfileScoreService.new(@tenant_applications).call

            @pagination = pagy_metadata(pagy)
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
