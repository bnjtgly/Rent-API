module Api
  class DomainsController < ApplicationController
    # before_action :authenticate_user!
    after_action { pagy_metadata(@pagy) if @pagy }

    # GET /api/domains
    def index
      pagy, @domains = pagy(Domain.includes(:domain_references))

      @domains = @domains.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%") unless params[:name].blank?

      @domains = @domains.where(domain_number: params[:domain_number]) unless params[:domain_number].blank?

      @pagination = pagy_metadata(pagy)

      render 'api/domains/index'
    end
  end
end
