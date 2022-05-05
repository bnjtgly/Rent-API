module PmApi
  class DomainReferencesController < ApplicationController
    before_action :authenticate_user!
    authorize_resource class: PmApi::DomainReferencesController

    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /pm_api/domain_references
    def index
      pagy, @domain_references = pagy(DomainReference.joins(:domain))

      unless params[:name].blank?
        @domain_references = @domain_references.where('LOWER(domains.name) LIKE ?', "%#{params[:name].downcase}%")
      end

      unless params[:domain_number].blank?
        @domain_references = @domain_references.where(domain: { domain_number: params[:domain_number] })
      end

      @pagination = pagy_metadata(pagy)
    end

    # GET /pm_api/domain_references/1
    def show
      @domain_reference = DomainReference.includes(:domain).where(domain_references: { id: params[:domain_reference_id] }).first

      if @domain_reference.nil?
        render json: { error: { domain_reference_id: ['Not Found.'] } }, status: :not_found
      end
    end
  end
end
