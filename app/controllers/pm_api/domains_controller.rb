module PmApi
  class DomainsController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::DomainsController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/domains
    def index
      pagy, @domains = pagy(Domain.includes(:domain_references))

      @domains = @domains.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?

      @domains = @domains.where(domain_number: params[:domain_number]) unless params[:domain_number].blank?

      @pagination = pagy_metadata(pagy)
    end

    # GET /pm_api/domains/1
    def show
      @domain = Domain.includes(:domain_references).where(domains: { id: params[:domain_id] }).first
      # @domain = Domain.includes(:domain_references).where(domains: { id: params[:domain_id] }, domain_references: { is_deleted: params[:is_deleted] }).first
      if @domain.nil?
        render json: { error: { domain_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end
