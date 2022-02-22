module AdminApi
  class DomainsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /admin_api/domains
    def index
      pagy, @domains = pagy(Domain.includes(:domain_references))

      @domains = @domains.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?

      @domains = @domains.where(domain_number: params[:domain_number]) unless params[:domain_number].blank?

      @pagination = pagy_metadata(pagy)

      render 'admin_api/domains/index'
    end

    # GET /admin_api/domains/1
    def show
      @domain = Domain.includes(:domain_references).where(domains: { id: params[:domain_id] }).first
      # @domain = Domain.includes(:domain_references).where(domains: { id: params[:domain_id] }, domain_references: { is_deleted: params[:is_deleted] }).first
      if !@domain.nil?
        render 'admin_api/domains/show'
      else
        render json: { error: { domain_id: ['Not Found.'] } }, status: :not_found
      end
    end

    # POST /admin_api/domains
    def create
      interact = AdminApi::CreateDomain.call(data: params)

      if interact.success?
        @domain = interact.domain
        render 'admin_api/domains/create'
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # PATCH/PUT /admin_api/domains/1
    def update
      interact = AdminApi::UpdateDomain.call(data: params)

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end

    # DELETE /admin_api/domains/1
    def destroy
      interact = AdminApi::DestroyDomain.call(id: params[:domain_id])

      if interact.success?
        render json: { message: 'Success' }
      else
        render json: { error: interact.error }, status: 422
      end
    end
  end
end
