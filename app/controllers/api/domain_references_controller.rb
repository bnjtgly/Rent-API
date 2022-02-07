module Api
  class DomainReferencesController < ApplicationController
    # before_action :authenticate_user!, except: [:index]
    # authorize_resource class: Api::DomainReferencesController

    # GET /api/domain_references
    def index
      # if (!params[:name].blank? || nil?) || !params[:domain_number].blank? || nil?
      #   @domain = Domain.includes(:domain_references)
      #
      #   @domain = @domain.where(domains: { name: params[:name] }) unless params[:name].blank?
      #
      #   @domain = @domain.where(domains: { domain_number: params[:domain_number] }) unless params[:domain_number].blank?
      #
      #   @domain = @domain.first
      #
      #   return render 'api/domain_references/index' if @domain
      # end
      #
      if (!params[:name].blank? || nil?) || !params[:domain_number].blank? || nil?
        @domain = Domain.includes(:domain_references)

        @domain = @domain.where(domains: { name: params[:name], sector: user_signed_in? ? 'PRIVATE' : 'PUBLIC' }) unless params[:name].blank?

        @domain = @domain.where(domains: { domain_number: params[:domain_number] }) unless params[:domain_number].blank?

        @domain = @domain.first

        return render 'api/domain_references/index' if @domain
      end

      render json: {}
    end
  end
end
