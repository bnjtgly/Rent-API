module AdminApi
  class DomainReferencesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/domain_references
    def index
      pagy, @domain_references = pagy(DomainReference.joins(:domain))

      @domain_references = @domain_references.where('LOWER(domains.name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?

      @domain_references = @domain_references.where(domain: { domain_number: params[:domain_number] }) unless params[:domain_number].blank?

      @pagination = pagy_metadata(pagy)

      render 'admin_api/domain_references/index'
    end

    # GET /admin_api/domain_references/1
    def show
      @domain_reference = DomainReference.includes(:domain).where(domain_references: { id: params[:domain_reference_id] }).first

      render 'admin_api/domain_references/show'
    end

    # POST /admin_api/domain_references
    def create
      interact = AdminApi::CreateDomainReference.call(data: params)

      if interact.success?
        @domain_reference = interact.domain_reference
        render 'admin_api/domain_references/create'
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # PATCH/PUT /admin_api/domain_references/1
    def update
      interact = AdminApi::UpdateDomainReference.call(data: params)

      if interact.success?
        @domain_reference = interact.domain_reference
        render 'admin_api/domain_references/show'
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # DELETE /admin_api/domain_references/1
    def destroy
      interact = AdminApi::DestroyDomainReference.call(data: params, id: params[:domain_reference_id])

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
